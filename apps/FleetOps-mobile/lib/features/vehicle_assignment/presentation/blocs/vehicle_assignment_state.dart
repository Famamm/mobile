import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

abstract class VehicleAssignmentState {}

class VehicleAssignmentInitial extends VehicleAssignmentState {}

class VehicleAssignmentLoading extends VehicleAssignmentState {}

class VehicleAssignmentLoaded extends VehicleAssignmentState {
  final List<Vehicle> vehicles;
  final List<Driver> drivers;
  final Driver? currentDriver;
  final int? selectedDriverId;
  final bool isCurrentDriverLoading;
  final String? currentDriverError;

  VehicleAssignmentLoaded({
    required this.vehicles,
    required this.drivers,
    this.currentDriver,
    this.selectedDriverId,
    this.isCurrentDriverLoading = false,
    this.currentDriverError,
  });
}

class VehicleAssignmentAssigning extends VehicleAssignmentState {
  final List<Vehicle> vehicles;
  final List<Driver> drivers;
  final Driver? currentDriver;

  VehicleAssignmentAssigning({
    required this.vehicles,
    required this.drivers,
    this.currentDriver,
  });
}

class VehicleAssignmentAssignmentSuccess extends VehicleAssignmentState {
  final String message;
  final Driver? currentDriver;

  VehicleAssignmentAssignmentSuccess({
    required this.message,
    this.currentDriver,
  });
}

class VehicleAssignmentError extends VehicleAssignmentState {
  final String message;

  VehicleAssignmentError({required this.message});
}
