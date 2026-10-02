abstract class VehicleAssignmentEvent {}

class LoadVehicleAssignmentEvent extends VehicleAssignmentEvent {}

class LoadCurrentDriverEvent extends VehicleAssignmentEvent {
  final int vehicleId;

  LoadCurrentDriverEvent({required this.vehicleId});
}

class LoadAvailableDriversEvent extends VehicleAssignmentEvent {}

class UnassignDriverEvent extends VehicleAssignmentEvent {
  final int vehicleId;

  UnassignDriverEvent({required this.vehicleId});
}

class SelectDriverEvent extends VehicleAssignmentEvent {
  final int driverId;

  SelectDriverEvent({required this.driverId});
}

class AssignVehicleDriverEvent extends VehicleAssignmentEvent {
  final int vehicleId;
  final int driverId;

  AssignVehicleDriverEvent({required this.vehicleId, required this.driverId});
}
