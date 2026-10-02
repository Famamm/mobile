import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserRepository repository;

  UserListBloc({required this.repository}) : super(UserListInitial()) {
    on<LoadUsers>(_onLoad);
    on<ChangePage>(_onChangePage);
  }

  Future<void> _onLoad(
    LoadUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    try {
      final result = await repository.getUsers();
      emit(UserListLoaded(result.users));
    } catch (e) {
      emit(UserListError(
        e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onChangePage(
    ChangePage event,
    Emitter<UserListState> emit,
  ) {
    final currentState = state;
    if (currentState is UserListLoaded) {
      emit(currentState.copyWith(currentPage: event.page));
    }
  }
}