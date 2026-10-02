import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/fleet_dashboard_repository.dart';
import 'fleet_dashboard_event.dart';
import 'fleet_dashboard_state.dart';

class FleetDashboardBloc
    extends Bloc<FleetDashboardEvent, FleetDashboardState> {
  final FleetDashboardRepository fleetDashboardRepository;

  FleetDashboardBloc({required this.fleetDashboardRepository})
    : super(FleetDashboardInitialState()) {
    on<LoadFleetDashboardEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadFleetDashboardEvent event,
    Emitter<FleetDashboardState> emit,
  ) async {
    emit(FleetDashboardLoadingState());
    try {
      final dashboard = await fleetDashboardRepository.getFleetDashboard();

      emit(FleetDashboardLoadedState(dashboard: dashboard));
    } catch (e) {
      print('❌ FleetDashboardBloc error: $e');
      emit(
        FleetDashboardErrorState(
          message:
              'Gagal memuat data dashboard. Periksa koneksi lalu coba lagi.',
        ),
      );
    }
  }
}
