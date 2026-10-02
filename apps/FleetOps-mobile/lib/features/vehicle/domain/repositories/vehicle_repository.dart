import '../entities/vehicle.dart';
import '../../data/models/vehicle_image_upload_dto.dart';

abstract interface class VehicleRepository {
  Future<Vehicle> addVehicle(VehicleImageUploadDTO dto);
  Future<List<Vehicle>> getVehiclesByDriver(int driverId);
  Future<List<Vehicle>> getVehiclesByOrganization(int organizationId);
  Future<Vehicle> getVehicleById(int vehicleId);
  Future<Vehicle> updateVehicle(int vehicleId, VehicleImageUploadDTO dto);
  Future<void> deleteVehicle(int vehicleId);
}
