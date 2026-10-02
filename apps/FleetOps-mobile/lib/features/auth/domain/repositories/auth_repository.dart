import '../../data/models/auth_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> login(String identity, String password);
  Future<void> registerOrganization(
    String organizationName,
    String fullName,
    String email,
    String password,
  );
  Future<AuthResponseModel> refreshToken(String refreshToken);
  Future<void> logout(String refreshToken);
  Future<void> logoutAllDevices();
}
