import 'package:core/core.dart';

import '../models/dashboard_model.dart';
import 'dashboard_remote_data_source.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final HttpService httpService;

  DashboardRemoteDataSourceImpl({required this.httpService});

  @override
  Future<DashboardModel> getDashboard() async {
    final endpoint = ApiConfig.driverGetDashboardEndpoint;

    final response = await httpService.get(endpoint);

    final data =
        response is Map<String, dynamic> && response.containsKey('data')
            ? response['data'] as Map<String, dynamic>
            : response as Map<String, dynamic>;

    return DashboardModel.fromJson(data);
  }
}
