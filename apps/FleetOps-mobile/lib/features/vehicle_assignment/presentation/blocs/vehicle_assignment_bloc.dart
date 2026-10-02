import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

import '../../domain/usecases/assign_vehicle_driver_usecase.dart';
import '../../domain/usecases/get_vehicle_assignment_usecase.dart';
import '../../domain/usecases/get_current_driver_usecase.dart';
import '../../domain/usecases/get_available_drivers_usecase.dart';
import '../../domain/usecases/unassign_driver_usecase.dart';
import 'vehicle_assignment_event.dart';
import 'vehicle_assignment_state.dart';

class VehicleAssignmentBloc
    extends Bloc<VehicleAssignmentEvent, VehicleAssignmentState> {
  final GetVehicleAssignmentUseCase getVehicleAssignmentUseCase;
  final AssignVehicleDriverUseCase assignVehicleDriverUseCase;
  final GetCurrentDriverUseCase getCurrentDriverUseCase;
  final GetAvailableDriversUseCase getAvailableDriversUseCase;
  final UnassignDriverUseCase unassignDriverUseCase;

  VehicleAssignmentBloc({
    required this.getVehicleAssignmentUseCase,
    required this.assignVehicleDriverUseCase,
    required this.getCurrentDriverUseCase,
    required this.getAvailableDriversUseCase,
    required this.unassignDriverUseCase,
  }) : super(VehicleAssignmentInitial()) {
    on<LoadVehicleAssignmentEvent>(_onLoad);
    on<SelectDriverEvent>(_onSelect);
    on<AssignVehicleDriverEvent>(_onAssign);
    on<LoadCurrentDriverEvent>(_onLoadCurrentDriver);
    on<LoadAvailableDriversEvent>(_onLoadAvailableDrivers);
    on<UnassignDriverEvent>(_onUnassign);
  }

  Future<void> _onLoadCurrentDriver(
    LoadCurrentDriverEvent event,
    Emitter<VehicleAssignmentState> emit,
  ) async {
    final initialState = state;
    if (initialState is! VehicleAssignmentLoaded) return;
    // Data pengemudi sebelumnya dikosongkan agar halaman detail tidak sempat
    // menampilkan "Belum ada pengemudi" atau pengemudi kendaraan lain.
    emit(
      VehicleAssignmentLoaded(
        vehicles: initialState.vehicles,
        drivers: initialState.drivers,
        selectedDriverId: initialState.selectedDriverId,
        isCurrentDriverLoading: true,
      ),
    );

    Driver? currentDriver;
    String? error;
    try {
      currentDriver = await getCurrentDriverUseCase(event.vehicleId);
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    final currentState = state;
    if (currentState is! VehicleAssignmentLoaded) return;
    emit(
      VehicleAssignmentLoaded(
        vehicles: currentState.vehicles,
        drivers: currentState.drivers,
        selectedDriverId: currentState.selectedDriverId,
        currentDriver: currentDriver,
        currentDriverError: error,
      ),
    );
  }

  Future<void> _onLoadAvailableDrivers(
    LoadAvailableDriversEvent event,
    Emitter<VehicleAssignmentState> emit,
  ) async {
    if (state is! VehicleAssignmentLoaded) return;
    try {
      final drivers = await getAvailableDriversUseCase();
      final currentState = state;
      if (currentState is! VehicleAssignmentLoaded) return;
      emit(
        VehicleAssignmentLoaded(
          vehicles: currentState.vehicles,
          drivers: drivers,
          selectedDriverId: currentState.selectedDriverId,
          currentDriver: currentState.currentDriver,
          isCurrentDriverLoading: currentState.isCurrentDriverLoading,
          currentDriverError: currentState.currentDriverError,
        ),
      );
    } catch (e) {
      final currentState = state;
      emit(
        VehicleAssignmentError(
          message: e.toString().replaceAll('Exception: ', ''),
        ),
      );
      // Kembali ke data terakhir agar daftar pengemudi tetap bisa dipakai.
      if (currentState is VehicleAssignmentLoaded) emit(currentState);
    }
  }

  Future<void> _onUnassign(
    UnassignDriverEvent event,
    Emitter<VehicleAssignmentState> emit,
  ) async {
    try {
      await unassignDriverUseCase(event.vehicleId);
      final currentState = state;
      if (currentState is VehicleAssignmentLoaded) {
        emit(
          VehicleAssignmentLoaded(
            vehicles: currentState.vehicles,
            drivers: currentState.drivers,
            currentDriver: null,
          ),
        );
      }
      emit(
        VehicleAssignmentAssignmentSuccess(
          message: 'Pengemudi berhasil dilepas',
        ),
      );
    } catch (e) {
      emit(
        VehicleAssignmentError(
          message: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoad(
    LoadVehicleAssignmentEvent event,
    Emitter<VehicleAssignmentState> emit,
  ) async {
    emit(VehicleAssignmentLoading());

    try {
      final assignment = await getVehicleAssignmentUseCase();
      emit(
        VehicleAssignmentLoaded(
          vehicles: assignment.vehicles,
          drivers: assignment.drivers,
        ),
      );
    } catch (e) {
      emit(
        VehicleAssignmentError(
          message: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onSelect(
    SelectDriverEvent event,
    Emitter<VehicleAssignmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is VehicleAssignmentLoaded) {
      emit(
        VehicleAssignmentLoaded(
          vehicles: currentState.vehicles,
          drivers: currentState.drivers,
          currentDriver: currentState.currentDriver,
          selectedDriverId: event.driverId,
          isCurrentDriverLoading: currentState.isCurrentDriverLoading,
          currentDriverError: currentState.currentDriverError,
        ),
      );
    }
  }

  Future<void> _onAssign(
    AssignVehicleDriverEvent event,
    Emitter<VehicleAssignmentState> emit,
  ) async {
    final currentState = state;
    if (currentState is VehicleAssignmentLoaded) {
      emit(
        VehicleAssignmentAssigning(
          vehicles: currentState.vehicles,
          drivers: currentState.drivers,
          currentDriver: currentState.currentDriver,
        ),
      );
    }

    try {
      await assignVehicleDriverUseCase(
        vehicleId: event.vehicleId,
        driverId: event.driverId,
      );

      final refreshed = await getVehicleAssignmentUseCase();
      final currentDriver = await getCurrentDriverUseCase(event.vehicleId);
      emit(
        VehicleAssignmentAssignmentSuccess(
          message: 'Pengemudi berhasil ditugaskan',
          currentDriver: currentDriver,
        ),
      );
      // State akhir tetap Loaded agar halaman detail langsung menampilkan
      // pengemudi baru tanpa perlu memuat ulang.
      emit(
        VehicleAssignmentLoaded(
          vehicles: refreshed.vehicles,
          drivers: refreshed.drivers,
          selectedDriverId: event.driverId,
          currentDriver: currentDriver,
        ),
      );
    } catch (e) {
      emit(
        VehicleAssignmentError(
          message: e.toString().replaceAll('Exception: ', ''),
        ),
      );
      // Kembali ke daftar sebelumnya agar pengguna bisa mencoba lagi.
      if (currentState is VehicleAssignmentLoaded) emit(currentState);
    }
  }
}
