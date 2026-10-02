import 'dart:io';

import '../models/create_fleet_manager_response_model.dart';
import '../models/fleet_manager_model.dart';

abstract class FleetManagerRemoteDataSource {
  Future<List<FleetManagerModel>> getFleetManagers();
  Future<FleetManagerModel> getFleetManagerById(int userId);
  Future<CreateFleetManagerResponseModel> createFleetManager({
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  });
  Future<FleetManagerModel> updateFleetManager({
    required int userId,
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  });
  Future<void> deleteFleetManager(int userId);

  Future<Map<String, String>> resetFleetManagerPassword(int userId);
}

