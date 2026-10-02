import '../entities/vehicle_assignment_entity.dart';
import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

abstract interface class VehicleAssignmentRepository {
  Future<VehicleAssignmentEntity> getVehicleAssignment();
  Future<Driver?> getCurrentDriver(int vehicleId);
  Future<List<Driver>> getAvailableDrivers();
  Future<void> assignDriver({required int vehicleId, required int driverId});
  Future<void> unassignDriver(int vehicleId);
}
