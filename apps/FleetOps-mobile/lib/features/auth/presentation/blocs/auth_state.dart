abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String accessToken;
  final String refreshToken;
  final String fullName;
  final String email;
  final String roleName;
  final String? username;
  final int? driverId;
  final int? organizationId;

  AuthSuccess({
    required this.accessToken,
    required this.refreshToken,
    required this.fullName,
    required this.email,
    required this.roleName,
    this.username,
    this.driverId,
    this.organizationId,
  });
}

class RegisterSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
