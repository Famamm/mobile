import 'dart:io';
import '../models/create_driver_dto.dart';
import '../models/driver_model.dart';
import '../../domain/entities/driver_credentials_result.dart';

abstract interface class DriverRemoteDataSource {
  Future<List<DriverModel>> getDrivers();
  Future<DriverModel> getDriverById(int driverId);
  Future<DriverCredentialsResult> createDriverWithCredentials(
      CreateDriverDTO dto,
      {File? profilePhoto,
      File? licensePhoto});
  Future<DriverModel> updateDriver(int driverId, CreateDriverDTO dto,
      {File? profilePhoto, File? licensePhoto});
  Future<void> deleteDriver(int driverId);
  Future<Map<String, String>> resetDriverPassword(int driverId);
}
