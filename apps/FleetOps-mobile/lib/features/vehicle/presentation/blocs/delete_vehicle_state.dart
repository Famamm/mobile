// lib/presentation/bloc/vehicle/vehicle_delete_state.dart
import 'package:equatable/equatable.dart';

abstract class VehicleDeleteState extends Equatable {
  const VehicleDeleteState();

  @override
  List<Object?> get props => [];
}

class VehicleDeleteInitial extends VehicleDeleteState {}

class VehicleDeleteLoading extends VehicleDeleteState {}

class VehicleDeleteSuccess extends VehicleDeleteState {
  final int vehicleId;
  final String message;

  const VehicleDeleteSuccess({
    required this.vehicleId,
    this.message = 'Vehicle deleted successfully',
  });

  @override
  List<Object?> get props => [vehicleId, message];
}

class VehicleDeleteFailure extends VehicleDeleteState {
  final String error;

  const VehicleDeleteFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
