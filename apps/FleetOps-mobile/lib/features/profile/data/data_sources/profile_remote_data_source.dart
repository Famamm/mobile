import '../models/admin_profile_model.dart';
import '../models/fleet_profile_model.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<AdminProfileModel> getAdminProfile();

  Future<FleetProfileModel> getFleetProfile();

  Future<void> selectVehicle(int vehicleId);
}
