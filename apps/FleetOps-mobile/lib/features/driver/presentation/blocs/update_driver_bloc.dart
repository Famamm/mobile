import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/driver_repository.dart';
import 'update_driver_event.dart';
import 'update_driver_state.dart';

class UpdateDriverBloc extends Bloc<UpdateDriverEvent, UpdateDriverState> {
  final DriverRepository repository;

  UpdateDriverBloc({required this.repository}) : super(UpdateDriverInitial()) {
    on<UpdateDriverSubmitted>(_onUpdateDriverSubmitted);
  }

  Future<void> _onUpdateDriverSubmitted(
    UpdateDriverSubmitted event,
    Emitter<UpdateDriverState> emit,
  ) async {
    emit(UpdateDriverLoading());
    try {
      final driver = await repository.updateDriver(
        event.driver,
        profilePhoto: event.profilePhoto,
        licensePhoto: event.licensePhoto,
      );
      emit(UpdateDriverSuccess(driver));
    } catch (e) {
      emit(UpdateDriverError(e.toString()));
    }
  }
}
