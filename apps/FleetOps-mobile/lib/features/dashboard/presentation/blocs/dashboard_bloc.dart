import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_dashboard_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboard;

  DashboardBloc({required this.getDashboard})
      : super(const DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await getDashboard(DashboardParams());
    result.fold(
      (failure) => emit(DashboardError(failure.toString())),
      (entity) => emit(DashboardLoaded(entity)),
    );
  }
}
