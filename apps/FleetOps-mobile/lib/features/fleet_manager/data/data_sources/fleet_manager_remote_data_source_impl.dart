import 'dart:io';

import 'package:core/core.dart';

import '../models/create_fleet_manager_response_model.dart';
import '../models/fleet_manager_model.dart';
import 'fleet_manager_remote_data_source.dart';

class FleetManagerRemoteDataSourceImpl implements FleetManagerRemoteDataSource {
  final HttpService httpService;

  FleetManagerRemoteDataSourceImpl({required this.httpService});

  static const String _baseEndpoint = 'api/admin/fleet-managers';

  @override
  Future<List<FleetManagerModel>> getFleetManagers() async {
    final response = await httpService.get(_baseEndpoint);

    final List raw = response is List
        ? response
        : (response is Map && response['data'] is List)
        ? response['data']
        : [];

    return raw
        .map((e) => FleetManagerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<FleetManagerModel> getFleetManagerById(int userId) async {
    final response =
        await httpService.get(
              ApiConfig.adminDetailFleetManagerEndpoint.replaceFirst(
                '{userId}',
                userId.toString(),
              ),
            )
            as Map<String, dynamic>;

    final data = response['data'] ?? response;
    return FleetManagerModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<CreateFleetManagerResponseModel> createFleetManager({
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  }) async {
    final response = await httpService.postForm(
      ApiConfig.adminCreateFleetManagerEndpoint,
      {'FullName': fullName, 'Address': address, 'PhoneNumber': phoneNumber},
      file: profilePhoto,
      fileFieldName: 'ProfilePhotoFile',
    );

    return CreateFleetManagerResponseModel.fromJson(response);
  }

  @override
  Future<FleetManagerModel> updateFleetManager({
    required int userId,
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  }) async {
    final response = await httpService.putForm(
      ApiConfig.adminUpdateFleetManagerEndpoint.replaceFirst(
        '{userId}',
        userId.toString(),
      ),
      {'FullName': fullName, 'Address': address, 'PhoneNumber': phoneNumber},
      file: profilePhoto,
      fileFieldName: 'ProfilePhotoFile',
    );

    final data = response['data'] ?? response;
    return FleetManagerModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteFleetManager(int userId) async {
    await httpService.delete(
      ApiConfig.adminDeleteFleetManagerEndpoint.replaceFirst(
        '{userId}',
        userId.toString(),
      ),
    );
  }

  @override
  Future<Map<String, String>> resetFleetManagerPassword(int userId) async {
    try {
      final response = await httpService.post(
        ApiConfig.adminResetFleetManagerPasswordEndpoint.replaceFirst(
          '{userId}',
          userId.toString(),
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

}
