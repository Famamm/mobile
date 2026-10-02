import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/driver_repository.dart';
import 'driver_list_event.dart';
import 'driver_list_state.dart';

class DriverListBloc extends Bloc<DriverListEvent, DriverListState> {
  final DriverRepository repository;

  DriverListBloc({required this.repository}) : super(DriverListInitial()) {
    on<LoadDriverList>(_onLoadDriverList);
    on<DeleteDriver>(_onDeleteDriver);
  }

  Future<void> _onLoadDriverList(
    LoadDriverList event,
    Emitter<DriverListState> emit,
  ) async {
    emit(DriverListLoading());
    try {
      final drivers = await repository.getDrivers();
      emit(DriverListLoaded(drivers));
    } catch (e) {
      print('❌ DriverListBloc load error: $e');
      emit(DriverListError(
        'Gagal memuat daftar pengemudi. Periksa koneksi lalu coba lagi.',
      ));
    }
  }

  Future<void> _onDeleteDriver(
    DeleteDriver event,
    Emitter<DriverListState> emit,
  ) async {
    emit(DriverListLoading());
    try {
      await repository.deleteDriver(event.driverId);
      emit(DriverDeleteSuccess());
      final drivers = await repository.getDrivers();
      emit(DriverListLoaded(drivers));
    } catch (e) {
      print('❌ DriverListBloc delete error: $e');
      emit(DriverListError(
        'Gagal menghapus pengemudi. Periksa koneksi lalu coba lagi.',
      ));
    }
  }
}
