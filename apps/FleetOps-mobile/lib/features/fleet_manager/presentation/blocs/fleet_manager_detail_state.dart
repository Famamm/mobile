import '../../domain/entities/fleet_manager_entity.dart';

abstract class FleetManagerDetailState {}

class FleetManagerDetailInitial extends FleetManagerDetailState {}
class FleetManagerDetailLoading extends FleetManagerDetailState {}

class FleetManagerDetailLoaded extends FleetManagerDetailState {
  final FleetManagerEntity fleetManager;
  FleetManagerDetailLoaded(this.fleetManager);
}

class FleetManagerDetailDeleteSuccess extends FleetManagerDetailState {}

class FleetManagerDetailError extends FleetManagerDetailState {
  final String message;
  FleetManagerDetailError(this.message);
}

class FleetManagerResetPasswordLoading extends FleetManagerDetailState {}

class FleetManagerResetPasswordSuccess extends FleetManagerDetailState {
  final String username;
  final String password;
  FleetManagerResetPasswordSuccess({
    required this.username,
    required this.password,
  });
}

class FleetManagerResetPasswordError extends FleetManagerDetailState {
  final String message;
  FleetManagerResetPasswordError(this.message);
}