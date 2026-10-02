import '../../domain/repositories/fleet_dashboard_repository.dart';
import '../data_sources/fleet_dashboard_remote_data_source.dart';
import '../models/fleet_dashboard_model.dart';

class FleetDashboardRepositoryImpl implements FleetDashboardRepository{
  final FleetDashboardRemoteDataSource remoteDataSource;

  FleetDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FleetDashboardModel> getFleetDashboard() async {
    final fleet = await remoteDataSource.getFleetDashboard();
    return FleetDashboardModel(
      totalDrivers: fleet.totalDrivers,
      totalVehicles: fleet.totalVehicles,
      activeVehicles: fleet.activeVehicles,
      unsignedVehicles: fleet.unsignedVehicles,
      unsignedDrivers: fleet.unsignedDrivers,
    );
  }
}