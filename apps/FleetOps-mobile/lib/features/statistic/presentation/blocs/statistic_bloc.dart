import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_statistic_usecase.dart';
import 'statistic_event.dart';
import 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final GetStatisticUseCase getStatistic;

  StatisticBloc({required this.getStatistic})
    : super(const StatisticInitial()) {
    on<LoadStatisticEvent>(_onLoadStatistic);
  }

  Future<void> _onLoadStatistic(
    LoadStatisticEvent event,
    Emitter<StatisticState> emit,
  ) async {
    emit(const StatisticLoading());
    final result = await getStatistic(
      StatisticParams(month: event.month, year: event.year),
    );
    result.fold(
      (failure) => emit(StatisticError(failure.toString())),
      (statistic) => emit(StatisticLoaded(statistic)),
    );
  }
}
