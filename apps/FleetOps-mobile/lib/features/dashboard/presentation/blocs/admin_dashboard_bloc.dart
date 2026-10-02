import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/admin_dashboard_repository.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardRepository adminDashboardRepository;

  AdminDashboardBloc({required this.adminDashboardRepository})
    : super(AdminDashboardInitial()) {
    on<LoadAdminDashboard>(_onLoad);
    on<LoadArmadaChart>(_onLoadArmada);
    on<LoadBbmChart>(_onLoadBbm);
  }

  Future<void> _onLoad(
    LoadAdminDashboard event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(AdminDashboardLoading());
    try {
      final dashboard = await adminDashboardRepository.getDashboard(
        bulan: event.bulan,
        tahun: event.tahun,
        rangeArmada: event.rangeArmada,
        rangeBbm: event.rangeBbm,
      );

      emit(AdminDashboardLoaded(dashboard: dashboard));
    } catch (e) {
      print('❌ AdminDashboardBloc error: $e');
      emit(
        AdminDashboardError(
          'Gagal memuat data dashboard. Periksa koneksi lalu coba lagi.',
        ),
      );
    }
  }

  /// Memuat ulang hanya chart aktivitas armada tanpa menampilkan loading.
  /// Chart BBM tetap memakai rentang dan data yang sama.
  Future<void> _onLoadArmada(
    LoadArmadaChart event,
    Emitter<AdminDashboardState> emit,
  ) async {
    final current = state;
    if (current is! AdminDashboardLoaded) {
      return _onLoad(LoadAdminDashboard(rangeArmada: event.rangeArmada), emit);
    }

    try {
      final dashboard = await adminDashboardRepository.getDashboard(
        rangeArmada: event.rangeArmada,
        rangeBbm: current.dashboard.rangeBbm,
      );
      emit(AdminDashboardLoaded(dashboard: dashboard));
    } catch (e) {
      print('❌ AdminDashboardBloc armada error: $e');
    }
  }

  /// Memuat ulang hanya chart biaya BBM tanpa menampilkan loading.
  /// Chart armada tetap memakai rentang dan data yang sama.
  Future<void> _onLoadBbm(
    LoadBbmChart event,
    Emitter<AdminDashboardState> emit,
  ) async {
    final current = state;
    if (current is! AdminDashboardLoaded) {
      return _onLoad(LoadAdminDashboard(rangeBbm: event.rangeBbm), emit);
    }

    try {
      final dashboard = await adminDashboardRepository.getDashboard(
        rangeArmada: current.dashboard.rangeArmada,
        rangeBbm: event.rangeBbm,
      );
      emit(AdminDashboardLoaded(dashboard: dashboard));
    } catch (e) {
      print('❌ AdminDashboardBloc bbm error: $e');
    }
  }
}
