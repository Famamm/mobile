import 'dart:io';
import 'package:core/core.dart';

import 'package:fleetops_mobile/features/inspection/data/data_sources/inspection_remote_data_source.dart';
import 'package:fleetops_mobile/features/inspection/data/models/inspection_item_model.dart';

class InspectionRemoteDataSourceImpl implements InspectionRemoteDataSource {
  final HttpService httpClientService;

  InspectionRemoteDataSourceImpl({required this.httpClientService});

  @override
  Future<List<InspectionItemModel>> getInspectionItems() async {
    try {
      final response = await httpClientService.get(
        ApiConfig.driverGetInspectionItemsEndpoint,
      );
      List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map && response['items'] != null) {
        data = response['items'] as List<dynamic>;
      } else {
        return [];
      }

      return data
          .map(
            (item) =>
                InspectionItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load inspection items: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getInspectionById(int id) async {
    try {
      final response = await httpClientService.get(
        ApiConfig.driverGetInspectionByIdEndpoint.replaceFirst(
          '{inspectionId}',
          id.toString(),
        ),
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get inspection: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getInspectionsByDriver(
    int driverId,
  ) async {
    try {
      final response = await httpClientService.get(
        ApiConfig.driverGetInspectionsByDriverEndpoint.replaceFirst(
          '{driverId}',
          driverId.toString(),
        ),
      );

      List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map && response['inspections'] != null) {
        data = response['inspections'] as List<dynamic>;
      } else {
        return [];
      }

      return data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to get inspections by driver: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getInspectionsByVehicle(
    int vehicleId,
  ) async {
    try {
      final response = await httpClientService.get(
        ApiConfig.driverGetInspectionsByVehicleEndpoint.replaceFirst(
          '{vehicleId}',
          vehicleId.toString(),
        ),
      );

      List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map && response['inspections'] != null) {
        data = response['inspections'] as List<dynamic>;
      } else {
        return [];
      }

      return data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to get inspections by vehicle: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTodayInspections() async {
    try {
      final response = await httpClientService.get(
        ApiConfig.driverGetMyTodayInspectionsEndpoint,
      );

      List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map && response['inspections'] != null) {
        data = response['inspections'] as List<dynamic>;
      } else {
        return [];
      }

      return data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to get today inspections: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateInspection({
    required int id,
    required int vehicleId,
    required int driverId,
    required DateTime inspectionDate,
    String? status,
    String? notes,
    List<String>? photoPaths,
  }) async {
    try {
      final fields = <String, String>{
        'vehicleId': vehicleId.toString(),
        'driverId': driverId.toString(),
        'inspectionDate': inspectionDate.toIso8601String(),
        if (status != null) 'status': status,
        if (notes != null) 'notes': notes,
      };

      // Jika ada foto, gunakan putWithFile
      if (photoPaths != null && photoPaths.isNotEmpty) {
        final firstFile = File(photoPaths[0]);
        if (await firstFile.exists()) {
          final response = await httpClientService.putWithFile(
            ApiConfig.driverUpdateInspectionEndpoint.replaceFirst(
              '{inspectionId}',
              id.toString(),
            ),
            fields,
            firstFile,
            'photos',
          );

          return response['inspection'] ?? response;
        }
      }

      // Jika tidak ada foto, gunakan patch biasa
      final response = await httpClientService.patch(
        ApiConfig.driverUpdateInspectionEndpoint.replaceFirst(
          '{inspectionId}',
          id.toString(),
        ),
        {
          'vehicleId': vehicleId,
          'driverId': driverId,
          'inspectionDate': inspectionDate.toIso8601String(),
          if (status != null) 'status': status,
          if (notes != null) 'notes': notes,
        },
      );

      return response['inspection'] ?? response;
    } catch (e) {
      throw Exception('Failed to update inspection: $e');
    }
  }

  @override
  Future<void> updateInspectionItems(
    int id,
    int vehicleId,
    int driverId,
    List<InspectionItemModel> items,
  ) async {
    try {
      final photoPaths = items
          .where(
            (e) =>
                e.photoPath != null &&
                !e.photoPath!.startsWith('camera://') &&
                !e.photoPath!.startsWith('gallery://'),
          )
          .map((e) => e.photoPath!)
          .toList();

      int conditionFromStatus(String status) => status == 'not_ok' ? 1 : 0;

      final fields = <String, String>{
        'vehicleId': vehicleId.toString(),
        'driverId': driverId.toString(),
      };

      final filtered = items.where((e) => e.status != 'none').toList();
      for (var i = 0; i < filtered.length; i++) {
        final item = filtered[i];
        if (item.dbId == null) continue;
        fields['Results[$i].ItemId'] = item.dbId.toString();
        fields['Results[$i].Condition'] = conditionFromStatus(
          item.status,
        ).toString();
        if (item.note != null && item.note!.isNotEmpty) {
          fields['Results[$i].Note'] = item.note!;
        }
      }

      final endpoint = ApiConfig.driverUpdateInspectionEndpoint.replaceFirst(
        '{inspectionId}',
        id.toString(),
      );

      if (photoPaths.isNotEmpty) {
        final file = File(photoPaths[0]);
        await httpClientService.putForm(
          endpoint,
          fields,
          file: file,
          fileFieldName: 'Photos',
        );
      } else {
        await httpClientService.putForm(endpoint, fields);
      }
    } catch (e) {
      throw Exception('Failed to update inspection: $e');
    }
  }

  @override
  Future<bool> deleteInspection(int id) async {
    try {
      await httpClientService.delete(
        ApiConfig.driverDeleteInspectionEndpoint.replaceFirst(
          '{inspectionId}',
          id.toString(),
        ),
      );
      return true;
    } catch (e) {
      throw Exception('Failed to delete inspection: $e');
    }
  }

  @override
  Future<void> submitInspection(
    int vehicleId,
    int driverId,
    List<InspectionItemModel> items,
  ) async {
    try {
      // Pisahkan items yang punya foto asli (bukan placeholder)
      final photoPaths = items
          .where(
            (e) =>
                e.photoPath != null &&
                !e.photoPath!.startsWith('camera://') &&
                !e.photoPath!.startsWith('gallery://'),
          )
          .map((e) => e.photoPath!)
          .toList();

      // Kondisi: 0 = ok, 1 = not_ok (sesuai backend InspectionCondition enum)
      int conditionFromStatus(String status) => status == 'not_ok' ? 1 : 0;

      // Bangun fields form
      final fields = <String, String>{
        'vehicleId': vehicleId.toString(),
        'driverId': driverId.toString(),
      };

      // Tambah Results sebagai indexed form fields
      final filtered = items.where((e) => e.status != 'none').toList();
      for (var i = 0; i < filtered.length; i++) {
        final item = filtered[i];
        if (item.dbId == null) continue;
        fields['Results[$i].ItemId'] = item.dbId.toString();
        fields['Results[$i].Condition'] = conditionFromStatus(
          item.status,
        ).toString();
        if (item.note != null && item.note!.isNotEmpty) {
          fields['Results[$i].Note'] = item.note!;
        }
      }

      if (photoPaths.isNotEmpty) {
        final file = File(photoPaths[0]);
        await httpClientService.postWithFile(
          ApiConfig.driverCreateInspectionEndpoint,
          fields,
          file,
          'Photos',
        );
      } else {
        await httpClientService.postForm(
          ApiConfig.driverCreateInspectionEndpoint,
          fields,
        );
      }
    } catch (e) {
      throw Exception('Failed to submit inspection: $e');
    }
  }
}
