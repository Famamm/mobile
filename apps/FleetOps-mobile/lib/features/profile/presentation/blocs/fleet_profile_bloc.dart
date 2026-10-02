import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_fleet_profile_usecase.dart';
import 'fleet_profile_event.dart';
import 'fleet_profile_state.dart';

class FleetProfileBloc extends Bloc<FleetProfileEvent, FleetProfileState> {
  final GetFleetProfileUseCase getFleetProfile;

  FleetProfileBloc({required this.getFleetProfile})
      : super(const FleetProfileInitial()) {
    on<LoadFleetProfileEvent>(_onLoadFleetProfile);
  }

  Future<void> _onLoadFleetProfile(
    LoadFleetProfileEvent event,
    Emitter<FleetProfileState> emit,
  ) async {
    emit(const FleetProfileLoading());
    final result = await getFleetProfile();
    result.fold(
      (failure) => emit(FleetProfileError(failure.toString())),
      (entity) => emit(FleetProfileLoaded(entity)),
    );
  }
}
