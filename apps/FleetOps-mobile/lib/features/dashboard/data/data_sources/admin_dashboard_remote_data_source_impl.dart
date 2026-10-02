import 'package:core/core.dart';

import '../models/admin_dashboard_model.dart';
import 'admin_dashboard_remote_data_source.dart';

class AdminDashboardRemoteDataSourceImpl implements AdminDashboardRemoteDataSource {
  final HttpService httpService;

  AdminDashboardRemoteDataSourceImpl({required this.httpService});

  @override
  Future<AdminDashboardModel> getDashboard({
    int? bulan,
    int? tahun,
    String? rangeArmada,
    String? rangeBbm,
  }) async {
    final query = <String, String>{};
    if (bulan != null) query['bulan'] = bulan.toString();
    if (tahun != null) query['tahun'] = tahun.toString();
    if (rangeArmada != null && rangeArmada.isNotEmpty) {
      query['rangeArmada'] = rangeArmada;
    }
    if (rangeBbm != null && rangeBbm.isNotEmpty) {
      query['rangeBbm'] = rangeBbm;
    }

    final queryString = query.isEmpty
        ? ''
        : '?${query.entries.map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}').join('&')}';

    final response =
        await httpService.get('${ApiConfig.adminGetDashboard}$queryString');

    final data = response is Map<String, dynamic> && response.containsKey('data')
        ? response['data']
        : response;

    return AdminDashboardModel.fromJson(data as Map<String, dynamic>);
  }
}
