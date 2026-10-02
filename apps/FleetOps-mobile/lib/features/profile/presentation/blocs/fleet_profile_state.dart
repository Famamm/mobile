import 'package:equatable/equatable.dart';

import '../../domain/entities/fleet_profile_entity.dart';

abstract class FleetProfileState extends Equatable {
  const FleetProfileState();

  @override
  List<Object> get props => [];
}

class FleetProfileInitial extends FleetProfileState {
  const FleetProfileInitial();
}

class FleetProfileLoading extends FleetProfileState {
  const FleetProfileLoading();
}

class FleetProfileLoaded extends FleetProfileState {
  final FleetProfileEntity entity;

  const FleetProfileLoaded(this.entity);

  @override
  List<Object> get props => [entity];
}

class FleetProfileError extends FleetProfileState {
  final String message;

  const FleetProfileError(this.message);

  @override
  List<Object> get props => [message];
}
