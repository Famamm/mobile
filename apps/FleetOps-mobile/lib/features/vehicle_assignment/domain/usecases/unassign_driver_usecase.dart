import '../repositories/vehicle_assignment_repository.dart';

class UnassignDriverUseCase {
  final VehicleAssignmentRepository repository;

  UnassignDriverUseCase(this.repository);

  Future<void> call(int vehicleId) {
    return repository.unassignDriver(vehicleId);
  }
}
