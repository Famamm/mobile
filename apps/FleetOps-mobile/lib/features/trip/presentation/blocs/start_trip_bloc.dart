import 'package:fleetops_mobile/features/trip/data/models/start_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/presentation/blocs/start_trip_event.dart';
import 'package:fleetops_mobile/features/trip/presentation/blocs/start_trip_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/trip_repository.dart';

class StartTripBloc extends Bloc<StartTripEvent, StartTripState> {
  final TripRepository repository;

  StartTripBloc({required this.repository}) : super(StartTripInitial()) {
    on<StartTripSubmitted>(_onStartTripSubmitted);
  }

  Future<void> _onStartTripSubmitted(
    StartTripSubmitted event,
    Emitter<StartTripState> emit,
  ) async {
    emit(StartTripLoading());

    try {
      if (event.titikAwal.isEmpty) {
        emit(
            StartTripError(message: 'Titik awal dan akhir tidak boleh kosong'));
        return;
      }

      if (event.odometerAwal < 0) {
        emit(StartTripError(message: 'Odometer awal tidak boleh negatif'));
        return;
      }

      print(
          '[StartTrip] driverId=${event.driverId} vehicleId=${event.vehicleId}');

      final startTripDTO = StartTripDTO(
        driverId: event.driverId,
        vehicleId: event.vehicleId,
        lokasiAwal: event.titikAwal,
        lokasiAkhir: event.titikAkhir,
        odometerAwal: event.odometerAwal,
        kordAwalLatitude: event.kordAwalLatitude,
        kordAwalLongitude: event.kordAwalLongitude,
      );

      final tripId = await repository.startTrip(startTripDTO);

      emit(StartTripSuccess(tripId: tripId.toString()));
    } catch (e) {
      emit(StartTripError(message: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
