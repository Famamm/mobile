import '../entities/vehicle_assignment_entity.dart';
import '../repositories/vehicle_assignment_repository.dart';

class GetVehicleAssignmentUseCase {
  final VehicleAssignmentRepository repository;

  GetVehicleAssignmentUseCase(this.repository);

  Future<VehicleAssignmentEntity> call() async {
    return repository.getVehicleAssignment();
  }
}
