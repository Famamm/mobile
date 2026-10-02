import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:fleetops_mobile/features/driver/data/models/driver_model.dart';
import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/vehicle/data/models/vehicle_model.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

import 'vehicle_assignment_remote_data_source.dart';

class VehicleAssignmentRemoteDataSourceImpl
    implements VehicleAssignmentRemoteDataSource {
  final HttpService httpService;

  VehicleAssignmentRemoteDataSourceImpl({required this.httpService});

  @override
  Future<List<Vehicle>> getVehicles() async {
    try {
      final response = await httpService.get(
        ApiConfig.fleetVehicleListEndpoint,
      );
      final data = response['vehicles'] as List<dynamic>? ?? [];

      return data
          .map((item) => VehicleModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat kendaraan: $e');
    }
  }

  @override
  Future<List<Driver>> getAvailableDrivers() async {
    try {
      final response = await httpService.get(
        ApiConfig.fleetAvailableDriversEndpoint,
      );
      final data = response['drivers'] as List<dynamic>? ?? [];

      // `map<Driver>` agar list benar-benar List<Driver>. Tanpa ini tipenya
      // List<DriverModel>, dan firstWhere(orElse: () => Driver(...)) crash.
      return data
          .map<Driver>((item) => _parseDriver(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat pengemudi: $e');
    }
  }

  @override
  Future<Driver?> getCurrentDriver(int vehicleId) async {
    final response = await httpService.get(
      ApiConfig.fleetCurrentDriverEndpoint.replaceFirst(
        '{vehicleId}',
        vehicleId.toString(),
      ),
    );
    final data = response['data'];
    if (data is! Map<String, dynamic>) return null;
    // Jika data pengemudi dibungkus di field `driver`, pakai objek tersebut.
    final driver = data['driver'];
    return _parseDriver(driver is Map<String, dynamic> ? driver : data);
  }

  Driver _parseDriver(Map<String, dynamic> json) {
    final driver = DriverModel.fromJson(json);
    if (kDebugMode && driver.name.isEmpty) {
      debugPrint(
        '[VehicleAssignment] Nama pengemudi #${driver.driverId} tidak '
        'ditemukan. Key dari API: ${json.keys.join(', ')}',
      );
    }
    return driver;
  }

  @override
  Future<void> assignDriver({
    required int vehicleId,
    required int driverId,
  }) async {
    await httpService.post(ApiConfig.fleetAssignmentEndpoint, {
      'vehicleId': vehicleId,
      'driverId': driverId,
    });
  }

  @override
  Future<void> unassignDriver(int vehicleId) async {
    await httpService.delete(
      ApiConfig.fleetUnassignDriverEndpoint.replaceFirst(
        '{vehicleId}',
        vehicleId.toString(),
      ),
    );
  }
}
