import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

class VehicleAssignmentEntity {
  final List<Vehicle> vehicles;
  final List<Driver> drivers;

  const VehicleAssignmentEntity({
    required this.vehicles,
    required this.drivers,
  });
}
