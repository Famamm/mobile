import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

abstract interface class VehicleAssignmentRemoteDataSource {
  Future<List<Vehicle>> getVehicles();
  Future<List<Driver>> getAvailableDrivers();
  Future<Driver?> getCurrentDriver(int vehicleId);
  Future<void> assignDriver({required int vehicleId, required int driverId});
  Future<void> unassignDriver(int vehicleId);
}
