
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserListResult> getUsers() async {
    final all = await remoteDataSource.getUsers();
    return UserListResult(count: all.length, users: all);
  }
}