import '../models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
}