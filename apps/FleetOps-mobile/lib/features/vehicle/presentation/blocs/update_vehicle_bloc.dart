import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../data/models/vehicle_image_upload_dto.dart';
import 'update_vehicle_event.dart';
import 'update_vehicle_state.dart';

class UpdateVehicleBloc extends Bloc<UpdateVehicleEvent, UpdateVehicleState> {
  final VehicleRepository repository;

  UpdateVehicleBloc({required this.repository})
    : super(UpdateVehicleInitial()) {
    on<UpdateVehicleSubmitted>(_onUpdateVehicleSubmitted);
  }

  Future<void> _onUpdateVehicleSubmitted(
    UpdateVehicleSubmitted event,
    Emitter<UpdateVehicleState> emit,
  ) async {
    emit(UpdateVehicleLoading());
    try {
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

      final vehicle = await repository.updateVehicle(event.vehicleId, dto);
      emit(UpdateVehicleSuccess(vehicle: vehicle));
    } catch (e) {
      emit(
        UpdateVehicleError(
          message: 'Gagal mengupdate kendaraan: ${e.toString()}',
        ),
      );
    }
  }
}
