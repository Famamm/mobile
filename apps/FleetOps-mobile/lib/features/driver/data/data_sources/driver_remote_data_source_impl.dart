import 'dart:io';

import 'package:core/core.dart';

import 'driver_remote_data_source.dart';
import '../models/create_driver_dto.dart';
import '../models/driver_model.dart';
import '../../domain/entities/driver_credentials_result.dart';

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final HttpService httpService;

  DriverRemoteDataSourceImpl({required this.httpService});

  @override
  Future<List<DriverModel>> getDrivers() async {
    try {
      final response = await httpService.get(
        ApiConfig.adminGetAllDriverEndpoint,
      );
      List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'] as List<dynamic>;
      } else {
        data = [];
      }
      return data
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat daftar pengemudi: $e');
    }
  }

  @override
  Future<DriverModel> getDriverById(int driverId) async {
    try {
      final response = await httpService.get(
        ApiConfig.adminGetByIdDriverEndpoint.replaceFirst(
          '{driverId}',
          driverId.toString(),
        ),
      );
      final data = (response is Map && response.containsKey('data'))
          ? response['data'] as Map<String, dynamic>
          : response as Map<String, dynamic>;
      return DriverModel.fromJson(data);
    } catch (e) {
      throw Exception('Gagal memuat data pengemudi: $e');
    }
  }
  
  @override
  Future<DriverModel> updateDriver(
    int driverId,
    CreateDriverDTO dto, {
    File? profilePhoto,
    File? licensePhoto,
  }) async {
    try {
      final fields = dto.toFormFields();
      final extraFiles = <String, File>{
        if (licensePhoto != null) 'FotoLisensiFile': licensePhoto,
      };
      final response = await httpService.putForm(
        ApiConfig.adminUpdateDriverEndpoint.replaceFirst(
          '{driverId}',
          driverId.toString(),
        ),
        fields,
        file: profilePhoto,
        fileFieldName: profilePhoto != null ? 'ProfilePhotoFile' : null,
        extraFiles: extraFiles.isEmpty ? null : extraFiles,
      );
      if (response.containsKey('data') && response['data'] != null) {
        return DriverModel.fromJson(response['data'] as Map<String, dynamic>);
      }
      return DriverModel(
        driverId: driverId,
        name: dto.fullName,
        phone: '',
        address: dto.address,
        role: 'Driver',
        status: dto.status,
        joinDate: '',
        licenseType: dto.jenisLisensi,
        licenseExpiry: dto.tanggalBerlaku,
        vehicleAssigned: '-',
        totalTrips: 0,
        rating: 5.0,
      );
    } catch (e) {
      throw Exception('Gagal mengubah data pengemudi: $e');
    }
  }

  @override
  Future<DriverCredentialsResult> createDriverWithCredentials(
    CreateDriverDTO dto, {
    File? profilePhoto,
    File? licensePhoto,
  }) async {
    try {
      final fields = dto.toFormFields();
      final extraFiles = <String, File>{
        if (licensePhoto != null) 'FotoLisensiFile': licensePhoto,
      };
      final response = await httpService.postForm(
        ApiConfig.adminCreateDriverEndpoint,
        fields,
        file: profilePhoto,
        fileFieldName: profilePhoto != null ? 'ProfilePhotoFile' : null,
        extraFiles: extraFiles.isEmpty ? null : extraFiles,
      );

      final data = response.containsKey('data') && response['data'] != null
          ? response['data'] as Map<String, dynamic>
          : response;

      final driver = DriverModel.fromJson(data);

      // Coba ambil username & password sebagai field terpisah dulu
      String? username =
          data['username'] as String? ??
          data['userName'] as String? ??
          data['email'] as String? ??
          response['username'] as String? ??
          response['userName'] as String? ??
          response['email'] as String?;
      String? password =
          data['generatedPassword'] as String? ??
          data['password'] as String? ??
          response['generatedPassword'] as String? ??
          response['password'] as String?;

      // Jika username kosong tapi password berformat "username/password", split
      if ((username == null || username.isEmpty) &&
          password != null &&
          password.contains('/')) {
        final lastSlash = password.lastIndexOf('/');
        username = password.substring(0, lastSlash);
        password = password.substring(lastSlash + 1);
      }

      return DriverCredentialsResult(
        driver: driver,
        username: username,
        password: password,
      );
    } catch (e) {
      throw Exception('Gagal menambahkan pengemudi: $e');
    }
  }

  @override
  Future<Map<String, String>> resetDriverPassword(int driverId) async {
    try {
      final response = await httpService.post(
        ApiConfig.adminResetDriverPasswordEndpoint.replaceFirst(
          '{driverId}',
          driverId.toString(),
        ),
        {},
      );
      final data = response.containsKey('data') && response['data'] != null
          ? response['data'] as Map<String, dynamic>
          : response;

      return {
        'username': data['username'] as String? ?? '',
        'password':
            data['generatedPassword'] as String? ??
            data['password'] as String? ??
            '',
      };
    } catch (e) {
      throw Exception('Gagal mereset password pengemudi: $e');
    }
  }

  @override
  Future<void> deleteDriver(int driverId) async {
    try {
      await httpService.delete(
        ApiConfig.adminDeleteDriverEndpoint.replaceFirst(
          '{driverId}',
          driverId.toString(),
        ),
      );
    } catch (e) {
      throw Exception('Gagal menghapus pengemudi: $e');
    }
  }
}
