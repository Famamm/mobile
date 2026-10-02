// lib/presentation/bloc/vehicle/vehicle_delete_event.dart
import 'package:equatable/equatable.dart';

abstract class VehicleDeleteEvent extends Equatable {
  const VehicleDeleteEvent();

  @override
  List<Object?> get props => [];
}

class DeleteVehicleRequested extends VehicleDeleteEvent {
  final int vehicleId;

  const DeleteVehicleRequested({required this.vehicleId});

  @override
  List<Object?> get props => [vehicleId];
}

class ResetDeleteStatus extends VehicleDeleteEvent {}
