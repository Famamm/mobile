class Auth {
  final int? userId;
  final int? driverId;
  final int? organizationId;
  final String fullName;
  final String email;
  final String roleName;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  Auth({
    this.userId,
    this.driverId,
    this.organizationId,
    required this.fullName,
    required this.email,
    required this.roleName,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
}
