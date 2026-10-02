import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fleet_manager_repository.dart';
import 'fleet_manager_detail_event.dart';
import 'fleet_manager_detail_state.dart';

class FleetManagerDetailBloc
    extends Bloc<FleetManagerDetailEvent, FleetManagerDetailState> {
  final FleetManagerRepository repository;

  FleetManagerDetailBloc({required this.repository})
    : super(FleetManagerDetailInitial()) {
    on<LoadFleetManagerDetail>(_onLoad);
    on<DeleteFleetManager>(_onDelete);
    on<ResetFleetManagerPassword>(_onResetPassword);
  }

  Future<void> _onLoad(
    LoadFleetManagerDetail event,
    Emitter<FleetManagerDetailState> emit,
  ) async {
    emit(FleetManagerDetailLoading());
    try {
      final manager = await repository.getFleetManagerById(event.userId);
      emit(FleetManagerDetailLoaded(manager));
    } catch (e) {
      emit(
        FleetManagerDetailError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> _onDelete(
    DeleteFleetManager event,
    Emitter<FleetManagerDetailState> emit,
  ) async {
    try {
      await repository.deleteFleetManager(event.userId);
      emit(FleetManagerDetailDeleteSuccess());
    } catch (e) {
      emit(
        FleetManagerDetailError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> _onResetPassword(
    ResetFleetManagerPassword event,
    Emitter<FleetManagerDetailState> emit,
  ) async {
    emit(FleetManagerResetPasswordLoading());
    try {
      final result = await repository.resetFleetManagerPassword(event.userId);
      emit(
        FleetManagerResetPasswordSuccess(
          username: result['username'] ?? '',
          password: result['password'] ?? '',
        ),
      );
    } catch (e) {
      emit(
        FleetManagerResetPasswordError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
