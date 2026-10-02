import 'package:equatable/equatable.dart';

abstract class FleetProfileEvent extends Equatable {
  const FleetProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadFleetProfileEvent extends FleetProfileEvent {
  const LoadFleetProfileEvent();
}
