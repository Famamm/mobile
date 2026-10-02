import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _roleNameKey = 'role_name';
  static const String _driverIdKey = 'driver_id';
  static const String _organizationIdKey = 'organization_id';
  static const String _activeVehicleIdKey = 'active_vehicle_id';
  static const String _activeVehicleNameKey = 'active_vehicle_name';
  static const String _activeVehiclePlatKey = 'active_vehicle_plat';
  static const String _activeVehicleOdometerKey = 'active_vehicle_odometer';
  static const String _activeVehicleTipeBensinKey =
      'active_vehicle_tipe_bensin';
  static const String _lastOdometerKey = 'last_odometer';

  final SharedPreferences _prefs;

  TokenService({required SharedPreferences prefs}) : _prefs = prefs;

  // Simpan token
  Future<void> saveToken(
    String token,
    String email,
    String fullName, {
    String? refreshToken,
    int? driverId,
    int? organizationId,
    String? roleName,
  }) async {
    // Cek apakah ini driver berbeda dari sesi sebelumnya
    final previousDriverId = _prefs.getInt(_driverIdKey);
    final isNewDriver = driverId != null &&
        previousDriverId != null &&
        previousDriverId != driverId;

    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userNameKey, fullName);
    if (refreshToken != null) {
      await _prefs.setString(_refreshTokenKey, refreshToken);
    }
    if (driverId != null) {
      await _prefs.setInt(_driverIdKey, driverId);
    }
    if (organizationId != null) {
      await _prefs.setInt(_organizationIdKey, organizationId);
    }
    if (roleName != null) {
      await _prefs.setString(_roleNameKey, roleName);
    }

    // Hapus data kendaraan sesi lama jika driver berbeda
    if (isNewDriver) {
      await _prefs.remove(_activeVehicleIdKey);
      await _prefs.remove(_activeVehicleNameKey);
      await _prefs.remove(_activeVehiclePlatKey);
      await _prefs.remove(_activeVehicleOdometerKey);
      await _prefs.remove(_lastOdometerKey);
    }
  }

  // Ambil token
  String? getToken() => _prefs.getString(_tokenKey);
  String? getRefreshToken() => _prefs.getString(_refreshTokenKey);
  String? getUserEmail() => _prefs.getString(_userEmailKey);
  String? getUserName() => _prefs.getString(_userNameKey);
  String? getRoleName() => _prefs.getString(_roleNameKey);
  int? getDriverId() => _prefs.getInt(_driverIdKey);
  int? getOrganizationId() => _prefs.getInt(_organizationIdKey);

  // Cek ada token atau tidak
  bool hasToken() => _prefs.containsKey(_tokenKey);

  // Cek role
  bool isAdmin() => getRoleName() == 'admin';
  bool isDriver() => getRoleName() == 'driver';

  // Simpan kendaraan aktif
  Future<void> saveActiveVehicle({
    required int vehicleId,
    required String vehicleName,
    required String platNomor,
    int? odometer,
    String? tipeBensin,
  }) async {
    await _prefs.setInt(_activeVehicleIdKey, vehicleId);
    await _prefs.setString(_activeVehicleNameKey, vehicleName);
    await _prefs.setString(_activeVehiclePlatKey, platNomor);
    if (odometer != null) {
      await _prefs.setInt(_activeVehicleOdometerKey, odometer);
      await _prefs.setInt(_lastOdometerKey, odometer);
    }
    if (tipeBensin != null) {
      await _prefs.setString(_activeVehicleTipeBensinKey, tipeBensin);
    }
  }

  int? getActiveVehicleId() => _prefs.getInt(_activeVehicleIdKey);
  String? getActiveVehicleName() => _prefs.getString(_activeVehicleNameKey);
  String? getActiveVehiclePlat() => _prefs.getString(_activeVehiclePlatKey);
  int getActiveVehicleOdometer() =>
      _prefs.getInt(_activeVehicleOdometerKey) ?? 0;
  String? getActiveVehicleTipeBensin() =>
      _prefs.getString(_activeVehicleTipeBensinKey);

  Future<void> saveLastOdometer(int odometer) async {
    await _prefs.setInt(_lastOdometerKey, odometer);
  }

  int getLastOdometer() => _prefs.getInt(_lastOdometerKey) ?? 0;

  // Hapus token (logout)
  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_roleNameKey);
    await _prefs.remove(_driverIdKey);
    await _prefs.remove(_organizationIdKey);
    await _prefs.remove(_activeVehicleIdKey);
    await _prefs.remove(_activeVehicleNameKey);
    await _prefs.remove(_activeVehiclePlatKey);
    await _prefs.remove(_activeVehicleOdometerKey);
    await _prefs.remove(_activeVehicleTipeBensinKey);
    await _prefs.remove(_lastOdometerKey);
  }
}
