import '../../domain/entities/admin_dashboard_entity.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';
import '../data_sources/admin_dashboard_remote_data_source.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminDashboardRemoteDataSource remoteDataSource;

  AdminDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdminDashboard> getDashboard({
    int? bulan,
    int? tahun,
    String? rangeArmada,
    String? rangeBbm,
  }) async {
    return remoteDataSource.getDashboard(
      bulan: bulan,
      tahun: tahun,
      rangeArmada: rangeArmada,
      rangeBbm: rangeBbm,
    );
  }
}