import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_inspection_histories_usecase.dart';
import '../../domain/usecases/get_inspection_summary_usecase.dart';
import 'inspection_history_event.dart';
import 'inspection_history_state.dart';

class InspectionHistoryBloc
    extends Bloc<InspectionHistoryEvent, InspectionHistoryState> {
  final GetInspectionHistoriesUseCase getHistories;
  final GetInspectionSummaryUseCase getSummary;

  InspectionHistoryBloc({
    required this.getHistories,
    required this.getSummary,
  }) : super(const InspectionHistoryState()) {
    on<InspectionHistoryStarted>(_onStarted);
    on<InspectionHistoryRefreshed>(_onRefreshed);
    on<InspectionHistorySearchChanged>(_onSearchChanged);
    on<InspectionHistoryFilterChanged>(_onFilterChanged);
  }

  Future<void> _onStarted(
    InspectionHistoryStarted event,
    Emitter<InspectionHistoryState> emit,
  ) async {
    emit(state.copyWith(status: InspectionHistoryStatus2.loading));
    await _loadData(emit);
  }

  Future<void> _onRefreshed(
    InspectionHistoryRefreshed event,
    Emitter<InspectionHistoryState> emit,
  ) async {
    emit(state.copyWith(status: InspectionHistoryStatus2.loading));
    await _loadData(emit);
  }

  Future<void> _onSearchChanged(
    InspectionHistorySearchChanged event,
    Emitter<InspectionHistoryState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    await _loadData(emit);
  }

  Future<void> _onFilterChanged(
    InspectionHistoryFilterChanged event,
    Emitter<InspectionHistoryState> emit,
  ) async {
    if (event.status == null) {
      emit(state.copyWith(clearFilter: true));
    } else {
      emit(state.copyWith(filterStatus: event.status));
    }
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<InspectionHistoryState> emit) async {
    try {
      final results = await Future.wait([
        getSummary(),
        getHistories(
          searchQuery: state.searchQuery,
          filterStatus: state.filterStatus,
        ),
      ]);

      emit(state.copyWith(
        status: InspectionHistoryStatus2.loaded,
        summary: results[0] as dynamic,
        histories: results[1] as dynamic,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InspectionHistoryStatus2.failure,
        errorMessage: 'Gagal memuat riwayat inspeksi.',
      ));
    }
  }
}
