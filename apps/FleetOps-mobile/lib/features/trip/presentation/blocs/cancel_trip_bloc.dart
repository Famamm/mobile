import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/features/trip/data/models/cancel_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/domain/repositories/trip_repository.dart';
import 'cancel_trip_event.dart';
import 'cancel_trip_state.dart';

class CancelTripBloc extends Bloc<CancelTripEvent, CancelTripState> {
  final TripRepository repository;

  CancelTripBloc({required this.repository}) : super(CancelTripInitial()) {
    on<CancelTripSubmitted>(_onCancelTripSubmitted);
  }

  Future<void> _onCancelTripSubmitted(
    CancelTripSubmitted event,
    Emitter<CancelTripState> emit,
  ) async {
    emit(CancelTripLoading());

    try {
      final cancelTripDTO = CancelTripDTO(driverId: event.driverId);

      await repository.cancelTrip(event.tripId, cancelTripDTO);

      emit(CancelTripSuccess(tripId: event.tripId.toString()));
    } catch (e) {
      emit(CancelTripError(message: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
