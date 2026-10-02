import '../../domain/entities/fleet_manager_entity.dart';

abstract class FleetManagerFormState {}

class FleetManagerFormInitial extends FleetManagerFormState {}
class FleetManagerFormSubmitting extends FleetManagerFormState {}

class FleetManagerFormCreateSuccess extends FleetManagerFormState {
  final FleetManagerEntity fleetManager;
  final String generatedPassword;
  FleetManagerFormCreateSuccess(this.fleetManager, this.generatedPassword);
}

class FleetManagerFormUpdateSuccess extends FleetManagerFormState {
  final FleetManagerEntity fleetManager;
  FleetManagerFormUpdateSuccess(this.fleetManager);
}

class FleetManagerFormError extends FleetManagerFormState {
  final String message;
  FleetManagerFormError(this.message);
}