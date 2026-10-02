import '../repositories/vehicle_assignment_repository.dart';

class AssignVehicleDriverUseCase {
  final VehicleAssignmentRepository repository;

  AssignVehicleDriverUseCase(this.repository);

  Future<void> call({required int vehicleId, required int driverId}) async {
    return repository.assignDriver(vehicleId: vehicleId, driverId: driverId);
  }
}
