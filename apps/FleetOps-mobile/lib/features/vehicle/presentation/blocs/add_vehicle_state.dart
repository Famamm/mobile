import '../../domain/entities/vehicle.dart';

abstract class AddVehicleState {}

class AddVehicleInitial extends AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleSuccess extends AddVehicleState {
  final Vehicle vehicle;
  AddVehicleSuccess({required this.vehicle});
}

class AddVehicleError extends AddVehicleState {
  final String message;
  AddVehicleError({required this.message});
}
