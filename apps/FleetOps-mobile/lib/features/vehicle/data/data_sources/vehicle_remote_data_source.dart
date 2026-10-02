import '../models/vehicle_model.dart';
import '../models/vehicle_image_upload_dto.dart';

abstract interface class VehicleRemoteDataSource {
  Future<VehicleModel> addVehicle(VehicleImageUploadDTO dto);
  Future<List<VehicleModel>> getVehiclesByDriver(int driverId);
  Future<List<VehicleModel>> getVehiclesByOrganization(int organizationId);
  Future<VehicleModel> getVehicleById(int vehicleId);
  Future<VehicleModel> updateVehicle(int vehicleId, VehicleImageUploadDTO dto);
  Future<void> deleteVehicle(int vehicleId);
}
