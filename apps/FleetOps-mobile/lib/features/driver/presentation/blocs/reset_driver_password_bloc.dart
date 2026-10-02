import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/driver_repository.dart';

abstract class ResetDriverPasswordState {}

class ResetDriverPasswordInitial extends ResetDriverPasswordState {}

class ResetDriverPasswordLoading extends ResetDriverPasswordState {}

class ResetDriverPasswordSuccess extends ResetDriverPasswordState {
  final String username;
  final String password;
  ResetDriverPasswordSuccess({required this.username, required this.password});
}

class ResetDriverPasswordError extends ResetDriverPasswordState {
  final String message;
  ResetDriverPasswordError(this.message);
}

class ResetDriverPasswordBloc extends Cubit<ResetDriverPasswordState> {
  final DriverRepository repository;

  ResetDriverPasswordBloc({required this.repository})
      : super(ResetDriverPasswordInitial());

  Future<void> reset(int driverId) async {
    emit(ResetDriverPasswordLoading());
    try {
      final result = await repository.resetDriverPassword(driverId);
      emit(ResetDriverPasswordSuccess(
        username: result['username'] ?? '',
        password: result['password'] ?? '',
      ));
    } catch (e) {
      emit(ResetDriverPasswordError(e.toString()));
    }
  }
}
