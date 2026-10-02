import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/features/trip/data/models/stop_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/domain/repositories/trip_repository.dart';
import 'end_trip_event.dart';
import 'end_trip_state.dart';

class EndTripBloc extends Bloc<EndTripEvent, EndTripState> {
  final TripRepository repository; // ← TAMBAH INI

  EndTripBloc({required this.repository}) : super(EndTripInitial()) {
    on<EndTripSubmitted>(_onEndTripSubmitted);
  }

  Future<void> _onEndTripSubmitted(
    EndTripSubmitted event,
    Emitter<EndTripState> emit,
  ) async {
    emit(EndTripLoading());

    try {
      if (event.dokumentasiFoto == null ||
          !event.dokumentasiFoto!.existsSync()) {
        emit(EndTripError(message: 'Dokumentasi foto wajib diunggah'));
        return;
      }

      if (event.odometerAkhir < event.odometerAwal) {
        emit(
          EndTripError(
            message:
                'Odometer akhir (${event.odometerAkhir} KM) harus lebih besar dari odometer awal (${event.odometerAwal} KM)',
          ),
        );
        return;
      }

      final stopTripDTO = StopTripDTO(
        driverId: event.driverId,
        vehicleId: event.vehicleId,
        lokasiAkhir: event.endLocation,
        odometerAkhir: event.odometerAkhir,
        kordAkhirLatitude: event.kordAkhirLatitude,
        kordAkhirLongitude: event.kordAkhirLongitude,
        catatan: event.note,
        dokumentasiFoto: event.dokumentasiFoto,
      );

      await repository.stopTrip(event.tripId, stopTripDTO); // ✅ NOW DEFINED

      emit(EndTripSuccess(tripId: event.tripId.toString()));
    } catch (e) {
      emit(EndTripError(message: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
