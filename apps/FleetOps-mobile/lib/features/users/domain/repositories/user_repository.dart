import '../entities/user.dart';

class UserListResult {
  final int count;
  final List<User> users;

  const UserListResult({required this.count, required this.users});
}

abstract class UserRepository {
  Future<UserListResult> getUsers();
}