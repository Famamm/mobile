import '../../domain/entities/vehicle.dart';

abstract class AdminVehicleListState {}

class AdminVehicleListInitial extends AdminVehicleListState {}

class AdminVehicleListLoading extends AdminVehicleListState {}

class AdminVehicleListLoaded extends AdminVehicleListState {
  final List<Vehicle> vehicles;
  AdminVehicleListLoaded({required this.vehicles});
}

class AdminVehicleListError extends AdminVehicleListState {
  final String message;
  AdminVehicleListError({required this.message});
}

class AdminVehicleDeleteSuccess extends AdminVehicleListState {}
