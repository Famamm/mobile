import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/driver.dart';
import '../../domain/repositories/driver_repository.dart';
import 'create_driver_event.dart';
import 'create_driver_state.dart';

class CreateDriverBloc extends Bloc<CreateDriverEvent, CreateDriverState> {
  final DriverRepository repository;

  CreateDriverBloc({required this.repository}) : super(CreateDriverInitial()) {
    on<CreateDriverSubmitted>(_onCreateDriverSubmitted);
  }

  Future<void> _onCreateDriverSubmitted(
    CreateDriverSubmitted event,
    Emitter<CreateDriverState> emit,
  ) async {
    emit(CreateDriverLoading());
    try {
      final driver = Driver(
        driverId: 0,
        name: event.fullName,
        phone: '',
        address: event.address,
        role: 'Driver',
        status: 'Active',
        joinDate: DateTime.now().toIso8601String().split('T').first,
        licenseType: event.licenseType,
        licenseExpiry: event.licenseExpiry,
        vehicleAssigned: '-',
        totalTrips: 0,
        rating: 5.0,
      );
      final result = await repository.createDriverWithCredentials(
        driver,
        profilePhoto: event.profilePhoto,
        licensePhoto: event.licensePhoto,
      );
      emit(CreateDriverSuccess(
        result.driver,
        generatedUsername: result.username,
        generatedPassword: result.password,
      ));
    } catch (e) {
      emit(CreateDriverError(e.toString()));
    }
  }
}
