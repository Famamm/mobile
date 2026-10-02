import '../../data/models/fleet_dashboard_model.dart';

abstract class FleetDashboardState {}

class FleetDashboardInitialState extends FleetDashboardState {}

class FleetDashboardLoadingState extends FleetDashboardState {}

class FleetDashboardLoadedState extends FleetDashboardState {
  final FleetDashboardModel dashboard;
  FleetDashboardLoadedState({required this.dashboard});
}

class FleetDashboardErrorState extends FleetDashboardState {
  final String message;
  FleetDashboardErrorState({required this.message});
}