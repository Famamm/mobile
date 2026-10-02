import '../../domain/entities/vehicle.dart';

abstract class UpdateVehicleState {}

class UpdateVehicleInitial extends UpdateVehicleState {}

class UpdateVehicleLoading extends UpdateVehicleState {}

class UpdateVehicleSuccess extends UpdateVehicleState {
  final Vehicle vehicle;
  UpdateVehicleSuccess({required this.vehicle});
}

class UpdateVehicleError extends UpdateVehicleState {
  final String message;
  UpdateVehicleError({required this.message});
}
