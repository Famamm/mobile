abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String identity;
  final String password;

  LoginEvent({required this.identity, required this.password});
}

class RegisterOrganizationEvent extends AuthEvent {
  final String organizationName;
  final String fullName;
  final String email;
  final String password;

  RegisterOrganizationEvent({
    required this.organizationName,
    required this.fullName,
    required this.email,
    required this.password,
  });
}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  RefreshTokenEvent({required this.refreshToken});
}

class LogoutEvent extends AuthEvent {
  final String refreshToken;

  LogoutEvent({required this.refreshToken});
}

class LogoutAllDevicesEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
