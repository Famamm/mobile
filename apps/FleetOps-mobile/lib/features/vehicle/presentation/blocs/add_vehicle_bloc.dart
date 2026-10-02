import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../data/models/vehicle_image_upload_dto.dart';
import 'add_vehicle_event.dart';
import 'add_vehicle_state.dart';

class AddVehicleBloc extends Bloc<AddVehicleEvent, AddVehicleState> {
  final VehicleRepository repository;

  AddVehicleBloc({required this.repository}) : super(AddVehicleInitial()) {
    on<AddVehicleSubmitted>(_onAddVehicleSubmitted);
  }

  Future<void> _onAddVehicleSubmitted(
    AddVehicleSubmitted event,
    Emitter<AddVehicleState> emit,
  ) async {
    emit(AddVehicleLoading());

    try {
      // Validation
      if (event.vehicleName.isEmpty ||
          event.platNomor.isEmpty ||
          event.tipe.isEmpty) {
        emit(AddVehicleError(message: 'Semua field wajib diisi'));
        return;
      }

      if (event.tahunPembuatan < 1900 || event.tahunPembuatan > 2100) {
        emit(AddVehicleError(message: 'Tahun pembuatan tidak valid'));
        return;
      }

      if (event.odometer < 0) {
        emit(AddVehicleError(message: 'Odometer tidak boleh negatif'));
        return;
      }

      final dto = VehicleImageUploadDTO(
        organizationId: event.organizationId,
        vehicleName: event.vehicleName,
        platNomor: event.platNomor,
        tahunPembuatan: event.tahunPembuatan,
        odometer: event.odometer,
        tipe: event.tipe,
        status: event.status,
        muatanMax: event.muatanMax,
        tipeBensin: event.tipeBensin,
        imagePath: event.imagePath,
      );

      final vehicle = await repository.addVehicle(dto);
      emit(AddVehicleSuccess(vehicle: vehicle));
    } catch (e) {
      emit(
        AddVehicleError(message: 'Gagal menambah kendaraan: ${e.toString()}'),
      );
    }
  }
}
