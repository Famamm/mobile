import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

import '../repositories/vehicle_assignment_repository.dart';

class GetAvailableDriversUseCase {
  final VehicleAssignmentRepository repository;

  GetAvailableDriversUseCase(this.repository);

  Future<List<Driver>> call() {
    return repository.getAvailableDrivers();
  }
}
