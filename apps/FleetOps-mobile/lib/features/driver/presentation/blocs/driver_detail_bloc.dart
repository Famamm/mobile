import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/features/driver/domain/repositories/driver_repository.dart';

import 'driver_detail_event.dart';
import 'driver_detail_state.dart';

class DriverDetailBloc extends Bloc<DriverDetailEvent, DriverDetailState> {
  final DriverRepository repository;

  DriverDetailBloc({required this.repository}) : super(DriverDetailInitial()) {
    on<LoadDriverDetail>(_onLoadDriverDetail);

    on<DeleteDriverFromDetail>(_onDelete);
  }

  Future<void> _onLoadDriverDetail(
    LoadDriverDetail event,
    Emitter<DriverDetailState> emit,
  ) async {
    emit(DriverDetailLoading());
    try {
      final driver = await repository.getDriverById(event.driverId);
      emit(DriverDetailLoaded(driver));
    } catch (e) {
      emit(DriverDetailError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteDriverFromDetail event,
    Emitter<DriverDetailState> emit,
  ) async {
    try {
      await repository.deleteDriver(event.driverId);
      emit(DriverDetailDeleteSuccess());
    } catch (e) {
      emit(DriverDetailError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
