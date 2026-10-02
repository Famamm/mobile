import 'package:core/core.dart';

import '../models/admin_profile_model.dart';
import '../models/fleet_profile_model.dart';
import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final HttpService httpService;

  ProfileRemoteDataSourceImpl({required this.httpService});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await httpService.get(
        ApiConfig.driverGetProfileEndpoint,
      );
      print('=== PROFILE RESPONSE ===');
      print(response);
      if (response is Map) {
        final data = response['data'];
        if (data is Map) {
          print('[DEBUG] kendaraanTersedia: ${data['kendaraanTersedia']}');
        }
      }
      print('========================');
      return ProfileModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      print('=== PROFILE ERROR: $e ===');
      throw Exception(msg);
    }
  }

  @override
  Future<AdminProfileModel> getAdminProfile() async {
    try {
      final response = await httpService.get(ApiConfig.adminGetProfile);
      return AdminProfileModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }

  @override
  Future<FleetProfileModel> getFleetProfile() async {
    try {
      final response = await httpService.get(ApiConfig.fleetGetProfile);
      return FleetProfileModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }

  @override
  Future<void> selectVehicle(int vehicleId) async {
    try {
      await httpService.put(ApiConfig.driverSelectVehicleEndpoint, {
        'vehicleId': vehicleId,
      });
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }
}
