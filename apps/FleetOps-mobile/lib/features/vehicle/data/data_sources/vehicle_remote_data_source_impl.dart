import 'dart:io';

import 'package:core/core.dart';

import '../models/vehicle_model.dart';
import '../models/vehicle_image_upload_dto.dart';
import 'vehicle_remote_data_source.dart';

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final HttpService httpService;

  VehicleRemoteDataSourceImpl({required this.httpService});

  // SUDAH UPDATE API
  @override
  Future<VehicleModel> addVehicle(VehicleImageUploadDTO dto) async {
    try {
      final fields = {
        'OrganizationId': dto.organizationId.toString(),
        'VehicleName': dto.vehicleName,
        'PlatNomor': dto.platNomor,
        'TahunPembuatan': dto.tahunPembuatan.toString(),
        'Odometer': dto.odometer.toString(),
        'Tipe': dto.tipe,
        'Status': dto.status,
        'MuatanMax': dto.muatanMax.toString(),
        'TipeBensin': dto.tipeBensin.toString(),
      };

      File? imageFile;
      if (dto.imagePath != null && dto.imagePath!.isNotEmpty) {
        imageFile = File(dto.imagePath!);
      }

      print('[ADD VEHICLE] Sending fields: $fields');
      final response = await httpService.postForm(
        ApiConfig.adminCreateVehicleEndpoint,
        fields,
        file: imageFile,
        fileFieldName: imageFile != null ? 'Image' : null,
      );

      print('=== ADD VEHICLE RESPONSE ===');
      print('Response: $response');
      print('===========================');

      return VehicleModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add vehicle: $e');
    }
  }

  @override
  Future<List<VehicleModel>> getVehiclesByDriver(int driverId) async {
    final response = await httpService.get(
      '${ApiConfig.getVehicleListEndpoint}/driver/$driverId',
    );

    if (response is List) {
      return (response)
          .map((item) => VehicleModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // SUDAH UPDATE API
  @override
  Future<List<VehicleModel>> getVehiclesByOrganization(
    int organizationId,
  ) async {
    try {
      final response = await httpService.get(
        ApiConfig.adminGetAllVehicleEndpoint,
      );

      List<dynamic> rawList = [];
      if (response is List) {
        rawList = response;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          rawList = response['data'] as List;
        } else {
          rawList = [response];
        }
      }

      // Fetch detail lengkap tiap kendaraan secara parallel
      final details = await Future.wait(
        rawList.map((item) async {
          final partial = item as Map<String, dynamic>;
          final id = partial['id'] as int? ?? partial['vehicleId'] as int? ?? 0;
          if (id == 0) return VehicleModel.fromJson(partial);
          try {
            final detail = await httpService.get('api/admin/vehicles/$id');
            return VehicleModel.fromJson(detail as Map<String, dynamic>);
          } catch (_) {
            return VehicleModel.fromJson(partial);
          }
        }),
      );

      return details;
    } catch (e) {
      print('❌ Error getVehiclesByOrganization: $e');
      return [];
    }
  }

  // SUDAH UPDATE API
  @override
  Future<VehicleModel> getVehicleById(int vehicleId) async {
    final response = await httpService.get(
      ApiConfig.adminGetByIdVehicleEndpoint.replaceFirst(
        '{vehicleId}',
        vehicleId.toString(),
      ),
    );
    return VehicleModel.fromJson(response as Map<String, dynamic>);
  }

  // SUDAH UPDATE API
  @override
  Future<VehicleModel> updateVehicle(
    int vehicleId,
    VehicleImageUploadDTO dto,
  ) async {
    try {
      final fields = {
        'OrganizationId': dto.organizationId.toString(),
        'VehicleName': dto.vehicleName,
        'PlatNomor': dto.platNomor,
        'TahunPembuatan': dto.tahunPembuatan.toString(),
        'Odometer': dto.odometer.toString(),
        'Tipe': dto.tipe,
        'Status': dto.status,
        'MuatanMax': dto.muatanMax.toString(),
        'TipeBensin': dto.tipeBensin.toString(),
      };

      File? imageFile;
      if (dto.imagePath != null && dto.imagePath!.isNotEmpty) {
        imageFile = File(dto.imagePath!);
      }

      final response = await httpService.putForm(
        ApiConfig.adminUpdateVehicleEndpoint.replaceFirst(
          '{vehicleId}',
          vehicleId.toString(),
        ),
        fields,
        file: imageFile,
        fileFieldName: imageFile != null ? 'Image' : null,
      );

      return VehicleModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
    }
  }

  // SUDAH UPDATE API
  @override
  Future<void> deleteVehicle(int vehicleId) async {
    await httpService.delete(
      ApiConfig.adminDeleteVehicleEndpoint.replaceFirst(
        '{vehicleId}',
        vehicleId.toString(),
      ),
    );
  }
}
