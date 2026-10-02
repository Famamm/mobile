import '../models/auth_response_model.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponseModel> login(String identity, String password) async {
    return await remoteDataSource.login(identity, password);
  }

  @override
  Future<void> registerOrganization(
    String organizationName,
    String fullName,
    String email,
    String password,
  ) async {
    return await remoteDataSource.registerOrganization(
      organizationName,
      fullName,
      email,
      password,
    );
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    return await remoteDataSource.refreshToken(refreshToken);
  }

  @override
  Future<void> logout(String refreshToken) async {
    await remoteDataSource.logout(refreshToken);
  }

  @override
  Future<void> logoutAllDevices() async {
    await remoteDataSource.logoutAllDevices();
  }
}
