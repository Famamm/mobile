import 'dart:io';
import '../entities/fleet_manager_entity.dart';

class CreateFleetManagerResult {
  final FleetManagerEntity fleetManager;
  final String generatedPassword;

  const CreateFleetManagerResult({
    required this.fleetManager,
    required this.generatedPassword,
  });
}

abstract class FleetManagerRepository {
  /// GET list — dipakai di halaman list
  Future<List<FleetManagerEntity>> getFleetManagers();

  /// GET detail
  Future<FleetManagerEntity> getFleetManagerById(int userId);

  /// POST — create
  Future<CreateFleetManagerResult> createFleetManager({
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  });

  /// PUT — update (termasuk foto opsional)
  Future<FleetManagerEntity> updateFleetManager({
    required int userId,
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  });

  /// DELETE
  Future<void> deleteFleetManager(int userId);

  
  Future<Map<String, String>> resetFleetManagerPassword(int userId);
}