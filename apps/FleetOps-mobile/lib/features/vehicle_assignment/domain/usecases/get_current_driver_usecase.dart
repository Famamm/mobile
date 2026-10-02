import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

import '../repositories/vehicle_assignment_repository.dart';

class GetCurrentDriverUseCase {
  final VehicleAssignmentRepository repository;

  GetCurrentDriverUseCase(this.repository);

  Future<Driver?> call(int vehicleId) {
    return repository.getCurrentDriver(vehicleId);
  }
}
