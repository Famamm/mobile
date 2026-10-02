import '../../domain/entities/user.dart';

abstract class UserListState {}

class UserListInitial extends UserListState {}
class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<User> users;
  final int currentPage;
  final int pageSize;

  UserListLoaded(
    this.users, {
    this.currentPage = 1,
    this.pageSize = 5,
  });

  List<User> get paginatedUsers {
    final start = (currentPage - 1) * pageSize;
    if (start >= users.length) return [];
    final end = start + pageSize;
    return users.sublist(start, end > users.length ? users.length : end);
  }

  int get totalPages => (users.length / pageSize).ceil();

  UserListLoaded copyWith({
    List<User>? users,
    int? currentPage,
    int? pageSize,
  }) {
    return UserListLoaded(
      users ?? this.users,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);
}