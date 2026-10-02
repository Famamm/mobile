import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

import '../../domain/repositories/vehicle_repository.dart';
import 'admin_vehicle_list_event.dart';
import 'admin_vehicle_list_state.dart';

class AdminVehicleListBloc
    extends Bloc<AdminVehicleListEvent, AdminVehicleListState> {
  final VehicleRepository repository;
  final TokenService tokenService;

  AdminVehicleListBloc({required this.repository, required this.tokenService})
    : super(AdminVehicleListInitial()) {
    on<LoadAdminVehicleList>(_onLoadAdminVehicleList);
    on<DeleteAdminVehicle>(_onDeleteAdminVehicle);
  }

  Future<void> _onLoadAdminVehicleList(
    LoadAdminVehicleList event,
    Emitter<AdminVehicleListState> emit,
  ) async {
    emit(AdminVehicleListLoading());
    try {
      // TokenService.getOrganizationId() mengembalikan int?, bukan String
      final organizationId = tokenService.getOrganizationId();
      print('🔍 Organization ID from token: $organizationId');

      if (organizationId == null) {
        emit(AdminVehicleListError(message: 'Organization ID tidak ditemukan'));
        return;
      }

      final vehicles = await repository.getVehiclesByOrganization(
        organizationId,
      );
      print('✅ Loaded ${vehicles.length} vehicles from API');

      emit(AdminVehicleListLoaded(vehicles: vehicles));
    } catch (e) {
      print('❌ Error loading vehicles: $e');
      emit(
        AdminVehicleListError(
          message:
              'Gagal memuat data kendaraan. Periksa koneksi lalu coba lagi.',
        ),
      );
    }
  }

  Future<void> _onDeleteAdminVehicle(
    DeleteAdminVehicle event,
    Emitter<AdminVehicleListState> emit,
  ) async {
    try {
      await repository.deleteVehicle(event.vehicleId);
      emit(AdminVehicleDeleteSuccess());
    } catch (e) {
      print('❌ Error deleting vehicle: $e');
      emit(
        AdminVehicleListError(
          message: 'Gagal menghapus kendaraan. Periksa koneksi lalu coba lagi.',
        ),
      );
    }
  }
}
