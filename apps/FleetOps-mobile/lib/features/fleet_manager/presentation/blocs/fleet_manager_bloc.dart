import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fleet_manager_repository.dart';
import 'fleet_manager_event.dart';
import 'fleet_manager_state.dart';

class FleetManagerFormBloc
    extends Bloc<FleetManagerFormEvent, FleetManagerFormState> {
  final FleetManagerRepository repository;

  FleetManagerFormBloc({required this.repository})
      : super(FleetManagerFormInitial()) {
    on<SubmitCreateFleetManager>(_onCreate);
    on<SubmitUpdateFleetManager>(_onUpdate);
    on<ResetFleetManagerForm>((_, emit) => emit(FleetManagerFormInitial()));
  }

  Future<void> _onCreate(
    SubmitCreateFleetManager event,
    Emitter<FleetManagerFormState> emit,
  ) async {
    emit(FleetManagerFormSubmitting());
    try {
      final res = await repository.createFleetManager(
        fullName: event.fullName,
        address: event.address,
        phoneNumber: event.phoneNumber,
        profilePhoto: event.profilePhoto,
      );
      emit(FleetManagerFormCreateSuccess(
        res.fleetManager,
        res.generatedPassword,
      ));
    } catch (e) {
      emit(FleetManagerFormError(
        e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onUpdate(
    SubmitUpdateFleetManager event,
    Emitter<FleetManagerFormState> emit,
  ) async {
    emit(FleetManagerFormSubmitting());
    try {
      final updated = await repository.updateFleetManager(
        userId: event.userId,
        fullName: event.fullName,
        address: event.address,
        phoneNumber: event.phoneNumber,
        profilePhoto: event.profilePhoto,
      );
      emit(FleetManagerFormUpdateSuccess(updated));
    } catch (e) {
      emit(FleetManagerFormError(
        e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}