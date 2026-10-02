import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

import '../../domain/entities/vehicle_assignment_entity.dart';

class VehicleAssignmentModel extends VehicleAssignmentEntity {
  const VehicleAssignmentModel({
    required super.vehicles,
    required super.drivers,
  });

  factory VehicleAssignmentModel.fromPayload({
    required List<Vehicle> vehicles,
    required List<Driver> drivers,
  }) {
    return VehicleAssignmentModel(vehicles: vehicles, drivers: drivers);
  }
}
