import '../models/fleet_dashboard_model.dart';

abstract class FleetDashboardRemoteDataSource {
  Future<FleetDashboardModel> getFleetDashboard();
}
