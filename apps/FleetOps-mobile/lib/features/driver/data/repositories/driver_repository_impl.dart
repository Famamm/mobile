import 'dart:io';

import '../../domain/entities/driver.dart';
import '../../domain/entities/driver_credentials_result.dart';
import '../../domain/repositories/driver_repository.dart';
import '../data_sources/driver_remote_data_source.dart';
import '../models/create_driver_dto.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource remoteDataSource;

  DriverRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Driver>> getDrivers() => remoteDataSource.getDrivers();

  @override
  Future<Driver> getDriverById(int driverId) =>
      remoteDataSource.getDriverById(driverId);

  @override
  Future<Driver> updateDriver(Driver driver,
      {File? profilePhoto, File? licensePhoto}) {
    final dto = CreateDriverDTO(
      fullName: driver.name,
      address: driver.address,
      jenisLisensi: driver.licenseType,
      tanggalBerlaku: driver.licenseExpiry,
      status: driver.status,
    );
    return remoteDataSource.updateDriver(driver.driverId, dto,
        profilePhoto: profilePhoto, licensePhoto: licensePhoto);
  }

  @override
  Future<DriverCredentialsResult> createDriverWithCredentials(
    Driver driver, {
    File? profilePhoto,
    File? licensePhoto,
  }) {
    final dto = CreateDriverDTO(
      fullName: driver.name,
      address: driver.address,
      jenisLisensi: driver.licenseType,
      tanggalBerlaku: driver.licenseExpiry,
      status: driver.status,
    );
    return remoteDataSource.createDriverWithCredentials(
      dto,
      profilePhoto: profilePhoto,
      licensePhoto: licensePhoto,
    );
  }

  @override
  Future<Map<String, String>> resetDriverPassword(int driverId) =>
      remoteDataSource.resetDriverPassword(driverId);

  @override
  Future<void> deleteDriver(int driverId) =>
      remoteDataSource.deleteDriver(driverId);
}
