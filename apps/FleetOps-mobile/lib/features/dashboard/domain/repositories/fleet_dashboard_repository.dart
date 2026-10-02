import '../../data/models/fleet_dashboard_model.dart';

abstract class FleetDashboardRepository {
  Future<FleetDashboardModel> getFleetDashboard();
}