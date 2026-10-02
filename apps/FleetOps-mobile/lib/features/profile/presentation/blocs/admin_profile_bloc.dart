import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_admin_profile_usecase.dart';
import 'admin_profile_event.dart';
import 'admin_profile_state.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  final GetAdminProfileUseCase getAdminProfile;

  AdminProfileBloc({required this.getAdminProfile})
      : super(const AdminProfileInitial()) {
    on<LoadAdminProfileEvent>(_onLoadAdminProfile);
  }

  Future<void> _onLoadAdminProfile(
    LoadAdminProfileEvent event,
    Emitter<AdminProfileState> emit,
  ) async {
    emit(const AdminProfileLoading());
    final result = await getAdminProfile();
    result.fold(
      (failure) => emit(AdminProfileError(failure.toString())),
      (entity) => emit(AdminProfileLoaded(entity)),
    );
  }
}
