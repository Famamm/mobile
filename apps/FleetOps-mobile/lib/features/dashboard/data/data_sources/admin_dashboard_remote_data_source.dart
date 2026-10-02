import '../models/admin_dashboard_model.dart';

abstract class AdminDashboardRemoteDataSource {
  Future<AdminDashboardModel> getDashboard({
    int? bulan,
    int? tahun,
    String? rangeArmada,
    String? rangeBbm,
  });
}