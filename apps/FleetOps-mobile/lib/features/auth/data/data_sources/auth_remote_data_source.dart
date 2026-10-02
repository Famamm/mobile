import 'package:core/core.dart';

import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String identity, String password);
  Future<void> registerOrganization(
    String organizationName,
    String fullName,
    String email,
    String password,
  );
  Future<AuthResponseModel> refreshToken(String refreshToken);
  Future<void> logout(String refreshToken);
  Future<void> logoutAllDevices();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpService httpService;

  AuthRemoteDataSourceImpl({required this.httpService});

  @override
  Future<AuthResponseModel> login(String identity, String password) async {
    final response = await httpService.post(
      ApiConfig.loginEndpoint,
      {
        'identity': identity,
        'password': password,
      },
    );
    return AuthResponseModel.fromJson(response);
  }

  @override
  Future<void> registerOrganization(
    String organizationName,
    String fullName,
    String email,
    String password,
  ) async {
    await httpService.post(
      ApiConfig.registerEndpoint,
      {
        'organizationName': organizationName,
        'fullName': fullName,
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await httpService.post(
      ApiConfig.refreshTokenEndpoint,
      RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
    );
    return AuthResponseModel.fromJson(response);
  }

  @override
  Future<void> logout(String refreshToken) async {
    await httpService.post(
      ApiConfig.logoutEndpoint,
      RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
    );
  }

  @override
  Future<void> logoutAllDevices() async {
    await httpService.post(
      ApiConfig.logoutAllDevicesEndpoint,
      {},
    );
  }
}
