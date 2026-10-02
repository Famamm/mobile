import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'token_service.dart';

class HttpService {
  final String baseUrl;
  String? _token;
  TokenService? _tokenService;
  Future<void> Function()? _onUnauthorized;

  // Mencegah multiple refresh berjalan bersamaan
  Future<bool>? _refreshFuture;

  String? get token => _token;

  void updateToken(String? newToken) {
    _token = newToken;
    _cachedToken = newToken;
  }

  /// Dipanggil dari injection_container setelah HttpService dibuat,
  /// agar auto-refresh bisa bekerja tanpa circular dependency.
  void configure({
    required TokenService tokenService,
    required Future<void> Function() onUnauthorized,
  }) {
    _tokenService = tokenService;
    _onUnauthorized = onUnauthorized;
  }

  HttpService({String? baseUrl, String? token})
    : baseUrl = baseUrl ?? ApiConfig.baseUrl,
      _token = token;

  static String? _cachedToken;

  static void setToken(String? token) {
    _cachedToken = token;
  }

  String? get _activeToken => _token ?? _cachedToken;

  Map<String, String> get _authHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_activeToken != null) 'Authorization': 'Bearer $_activeToken',
  };

  // ─── Token Refresh ──────────────────────────────────────────────────────────

  /// Coba refresh access token. Return true jika berhasil.
  /// Memakai _refreshFuture agar concurrent request tidak memicu multi-refresh.
  Future<bool> _tryRefresh() {
    _refreshFuture ??= _doRefresh().whenComplete(() => _refreshFuture = null);
    return _refreshFuture!;
  }

  Future<bool> _doRefresh() async {
    final tokenService = _tokenService;
    if (tokenService == null) return false;

    final storedRefresh = tokenService.getRefreshToken();
    if (storedRefresh == null || storedRefresh.isEmpty) return false;

    try {
      print('[AUTH] Access token expired — trying refresh...');
      final response = await http
          .post(
            Uri.parse('$baseUrl${ApiConfig.refreshTokenEndpoint}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refreshToken': storedRefresh}),
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess = json['accessToken'] as String?;
        final newRefresh = json['refreshToken'] as String?;
        if (newAccess == null) return false;

        _token = newAccess;
        _cachedToken = newAccess;
        await tokenService.saveToken(
          newAccess,
          tokenService.getUserEmail() ?? '',
          tokenService.getUserName() ?? '',
          refreshToken: newRefresh,
          driverId: tokenService.getDriverId(),
          organizationId: tokenService.getOrganizationId(),
          roleName: tokenService.getRoleName(),
        );
        print('[AUTH] Token refreshed successfully.');
        return true;
      }
    } catch (e) {
      print('[AUTH] Refresh request failed: $e');
    }
    return false;
  }

  Future<void> _forceLogout() async {
    print('[AUTH] Refresh token invalid/expired — forcing logout.');
    await _tokenService?.clearToken();
    _cachedToken = null;
    _token = null;
    await _onUnauthorized?.call();
  }

  // ─── Error Helpers ───────────────────────────────────────────────────────────

  String _extractErrorMessage(String responseBody) {
    try {
      final json = jsonDecode(responseBody) as Map<String, dynamic>;
      if (json.containsKey('message')) {
        return json['message'] as String? ?? 'Unknown error';
      }
      if (json.containsKey('error')) {
        return json['error'] as String? ?? 'Unknown error';
      }
      if (json.containsKey('errors')) {
        final errors = json['errors'];
        if (errors is Map) return errors.values.first.toString();
        return errors.toString();
      }
      if (json['detail'] is String) return json['detail'] as String;
      if (json['title'] is String) return json['title'] as String;
      return 'Server Error: $json';
    } catch (_) {
      return responseBody.isEmpty ? 'Unknown error' : responseBody;
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is SocketException) return 'Koneksi internet tidak tersedia';
    if (error is TimeoutException) return 'Koneksi ke server timeout';
    if (error.toString().contains('SocketException'))
      return 'Koneksi ke server gagal';
    if (error.toString().contains('ClientException'))
      return 'Gagal terhubung ke server';
    if (error is Exception) {
      final msg = error.toString();
      return msg.contains('Exception: ')
          ? msg.replaceAll('Exception: ', '')
          : msg;
    }
    return 'Terjadi kesalahan, coba lagi';
  }

  // ─── GET ─────────────────────────────────────────────────────────────────────

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: _authHeaders)
          .timeout(const Duration(seconds: ApiConfig.receiveTimeoutSeconds));

      print('[HTTP] GET $endpoint → ${response.statusCode}');

      if (response.statusCode == 401) {
        if (await _tryRefresh()) {
          final retry = await http
              .get(Uri.parse('$baseUrl$endpoint'), headers: _authHeaders)
              .timeout(
                const Duration(seconds: ApiConfig.receiveTimeoutSeconds),
              );
          if (retry.statusCode >= 200 && retry.statusCode < 300) {
            return _parseBody(retry.body);
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseBody(response.body);
      }
      throw Exception(
        'HTTP ${response.statusCode}: ${_extractErrorMessage(response.body)}',
      );
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ─── POST ────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _authHeaders,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeoutSeconds));

      print('[HTTP] POST $endpoint → ${response.statusCode}');

      // ✅ Cek apakah ini endpoint login atau refresh
      final bool isAuthEndpoint =
          endpoint.contains('/auth/login') ||
          endpoint.contains('/auth/refresh') ||
          endpoint.contains('/auth/register');

      // ✅ Handle 401 untuk login/register/refresh
      if (response.statusCode == 401 && isAuthEndpoint) {
        // Parse error message dari backend
        final errorMsg = _extractErrorMessage(response.body);

        // Cek pesan error spesifik
        if (errorMsg.contains('Invalid credentials') ||
            errorMsg.contains('invalid credentials') ||
            errorMsg.contains('Invalid email') ||
            errorMsg.contains('Password')) {
          throw Exception('Username atau password salah');
        }

        if (errorMsg.contains('already registered') ||
            errorMsg.contains('Email already')) {
          throw Exception('Email sudah terdaftar');
        }

        // Throw error message dari backend
        throw Exception(errorMsg);
      }

      if (response.statusCode == 401 && !isAuthEndpoint) {
        if (await _tryRefresh()) {
          final retry = await http
              .post(
                Uri.parse('$baseUrl$endpoint'),
                headers: _authHeaders,
                body: jsonEncode(data),
              )
              .timeout(
                const Duration(seconds: ApiConfig.connectionTimeoutSeconds),
              );
          if (retry.statusCode >= 200 && retry.statusCode < 300) {
            return _parseBodyAsMap(retry.body);
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseBodyAsMap(response.body);
      }
      throw Exception(_extractErrorMessage(response.body));
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ─── POST FORM (multipart) ───────────────────────────────────────────────────

  Future<Map<String, dynamic>> postForm(
    String endpoint,
    Map<String, String> fields, {
    File? file,
    String? fileFieldName,
    Map<String, File>? extraFiles,
  }) async {
    try {
      var response = await _sendMultipart(
        'POST',
        endpoint,
        fields,
        file,
        fileFieldName,
        extraFiles: extraFiles,
      );

      print('[HTTP] POST (form) $endpoint → ${response.statusCode}');

      if (response.statusCode == 401) {
        if (await _tryRefresh()) {
          response = await _sendMultipart(
            'POST',
            endpoint,
            fields,
            file,
            fileFieldName,
            extraFiles: extraFiles,
          );
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final body = await response.stream.bytesToString();
            return body.isEmpty ? {} : jsonDecode(body) as Map<String, dynamic>;
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      final body = await response.stream.bytesToString();
      print('[HTTP] POST (form) body: $body');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body.isEmpty ? {} : jsonDecode(body) as Map<String, dynamic>;
      }
      throw Exception(_extractErrorMessage(body));
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ─── PUT ─────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _authHeaders,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeoutSeconds));

      print('[HTTP] PUT $endpoint → ${response.statusCode}');

      if (response.statusCode == 401) {
        if (await _tryRefresh()) {
          final retry = await http
              .put(
                Uri.parse('$baseUrl$endpoint'),
                headers: _authHeaders,
                body: jsonEncode(data),
              )
              .timeout(
                const Duration(seconds: ApiConfig.connectionTimeoutSeconds),
              );
          if (retry.statusCode >= 200 && retry.statusCode < 300) {
            return _parseBodyAsMap(retry.body);
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseBodyAsMap(response.body);
      }
      throw Exception(_extractErrorMessage(response.body));
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ─── PUT FORM (multipart) ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> putForm(
    String endpoint,
    Map<String, String> fields, {
    File? file,
    String? fileFieldName,
    Map<String, File>? extraFiles,
  }) async {
    try {
      var response = await _sendMultipart(
        'PUT',
        endpoint,
        fields,
        file,
        fileFieldName,
        extraFiles: extraFiles,
      );

      print('[HTTP] PUT (form) $endpoint → ${response.statusCode}');

      if (response.statusCode == 401) {
        if (await _tryRefresh()) {
          response = await _sendMultipart(
            'PUT',
            endpoint,
            fields,
            file,
            fileFieldName,
            extraFiles: extraFiles,
          );
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final body = await response.stream.bytesToString();
            return body.isEmpty ? {} : jsonDecode(body) as Map<String, dynamic>;
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      final body = await response.stream.bytesToString();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body.isEmpty ? {} : jsonDecode(body) as Map<String, dynamic>;
      }
      throw Exception(_extractErrorMessage(body));
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ─── PATCH ───────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl$endpoint'),
            headers: _authHeaders,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: ApiConfig.connectionTimeoutSeconds));

      print('[HTTP] PATCH $endpoint → ${response.statusCode}');

      if (response.statusCode == 401) {
        if (await _tryRefresh()) {
          final retry = await http
              .patch(
                Uri.parse('$baseUrl$endpoint'),
                headers: _authHeaders,
                body: jsonEncode(data),
              )
              .timeout(
                const Duration(seconds: ApiConfig.connectionTimeoutSeconds),
              );
          if (retry.statusCode >= 200 && retry.statusCode < 300) {
            return _parseBodyAsMap(retry.body);
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseBodyAsMap(response.body);
      }
      throw Exception(_extractErrorMessage(response.body));
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ─── DELETE ──────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl$endpoint'), headers: _authHeaders)
          .timeout(const Duration(seconds: ApiConfig.connectionTimeoutSeconds));

      print('[HTTP] DELETE $endpoint → ${response.statusCode}');

      if (response.statusCode == 401) {
        if (await _tryRefresh()) {
          final retry = await http
              .delete(Uri.parse('$baseUrl$endpoint'), headers: _authHeaders)
              .timeout(
                const Duration(seconds: ApiConfig.connectionTimeoutSeconds),
              );
          if (retry.statusCode >= 200 && retry.statusCode < 300) {
            return _parseBodyAsMap(retry.body);
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseBodyAsMap(response.body);
      }
      throw Exception(_extractErrorMessage(response.body));
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Kirim multipart request. Stream hanya bisa dibaca sekali, jadi kembalikan
  /// http.StreamedResponse — caller yang baca stream-nya.
  Future<http.StreamedResponse> _sendMultipart(
    String method,
    String endpoint,
    Map<String, String> fields,
    File? file,
    String? fileFieldName, {
    Map<String, File>? extraFiles,
  }) async {
    final request =
        http.MultipartRequest(method, Uri.parse('$baseUrl$endpoint'))
          ..fields.addAll(fields)
          ..headers.addAll({
            'Accept': 'application/json',
            if (_activeToken != null) 'Authorization': 'Bearer $_activeToken',
          });

    if (file != null && fileFieldName != null && await file.exists()) {
      request.files.add(
        await http.MultipartFile.fromPath(fileFieldName, file.path),
      );
    }

    if (extraFiles != null) {
      for (final entry in extraFiles.entries) {
        if (await entry.value.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }
    }

    return request.send().timeout(ApiConfig.connectTimeout);
  }

  dynamic _parseBody(String body) {
    if (body.isEmpty) return [];
    try {
      return jsonDecode(body);
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _parseBodyAsMap(String body) {
    if (body.isEmpty) return {};
    return jsonDecode(body) as Map<String, dynamic>;
  }

  // ─── Metode lama yang masih dipakai beberapa tempat ─────────────────────────

  Future<Map<String, dynamic>> postWithFile(
    String endpoint,
    Map<String, String> fields,
    File file,
    String fileFieldName,
  ) => postForm(endpoint, fields, file: file, fileFieldName: fileFieldName);

  Future<Map<String, dynamic>> putWithFile(
    String endpoint,
    Map<String, String> fields,
    File file,
    String fileFieldName,
  ) => putForm(endpoint, fields, file: file, fileFieldName: fileFieldName);

  Future<Map<String, dynamic>> patchWithFile(
    String endpoint,
    Map<String, String> fields,
    File file,
    String fileFieldName,
  ) async {
    try {
      var response = await _sendMultipart(
        'PATCH',
        endpoint,
        fields,
        file,
        fileFieldName,
      );

      if (response.statusCode == 401) {
        if (await _tryRefresh()) {
          response = await _sendMultipart(
            'PATCH',
            endpoint,
            fields,
            file,
            fileFieldName,
          );
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final body = await response.stream.bytesToString();
            return body.isEmpty ? {} : jsonDecode(body) as Map<String, dynamic>;
          }
        }
        await _forceLogout();
        throw Exception('Sesi telah berakhir, silakan login kembali');
      }

      final body = await response.stream.bytesToString();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body.isEmpty ? {} : jsonDecode(body) as Map<String, dynamic>;
      }
      throw Exception(_extractErrorMessage(body));
    } catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }
}
