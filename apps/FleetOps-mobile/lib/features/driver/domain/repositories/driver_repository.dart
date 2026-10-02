import 'dart:io';
import '../entities/driver.dart';
import '../entities/driver_credentials_result.dart';

abstract interface class DriverRepository {
  Future<List<Driver>> getDrivers();
  Future<Driver> getDriverById(int driverId);
  Future<DriverCredentialsResult> createDriverWithCredentials(Driver driver,
      {File? profilePhoto, File? licensePhoto});
  Future<Driver> updateDriver(Driver driver,
      {File? profilePhoto, File? licensePhoto});
  Future<void> deleteDriver(int driverId);
  Future<Map<String, String>> resetDriverPassword(int driverId);
}
