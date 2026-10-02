import 'package:core/core.dart';

import '../models/fleet_dashboard_model.dart';
import 'fleet_dashboard_remote_data_source.dart';

class FleetDashboardRemoteDataSourceImpl
    implements FleetDashboardRemoteDataSource {
  final HttpService httpService;

  FleetDashboardRemoteDataSourceImpl({required this.httpService});

  @override
  Future<FleetDashboardModel> getFleetDashboard() async {
    final endpoint = ApiConfig.fleetGetDashboardEndpoint;

    final response = await httpService.get(endpoint);

    final data =
        response is Map<String, dynamic> && response.containsKey('data')
        ? response['data'] as Map<String, dynamic>
        : response as Map<String, dynamic>;

    return FleetDashboardModel.fromJson(data);
  }
}
