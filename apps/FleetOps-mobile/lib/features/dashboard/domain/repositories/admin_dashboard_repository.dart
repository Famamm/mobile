import '../entities/admin_dashboard_entity.dart';

abstract class AdminDashboardRepository {
  Future<AdminDashboard> getDashboard({
    int? bulan,
    int? tahun,
    String? rangeArmada,
    String? rangeBbm,
  });
}