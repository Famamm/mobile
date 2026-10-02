class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresIn': expiresIn,
        'user': user.toJson(),
      };
}

class UserModel {
  final int? userId;
  final int? driverId;
  final int? organizationId;
  final String fullName;
  final String email;
  final String roleName;
  final String? username;

  UserModel({
    this.userId,
    this.driverId,
    this.organizationId,
    required this.fullName,
    required this.email,
    required this.roleName,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int?,
      driverId: json['driverId'] as int?,
      organizationId: json['organizationId'] as int?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      roleName: json['roleName'] as String,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'driverId': driverId,
        'organizationId': organizationId,
        'fullName': fullName,
        'email': email,
        'roleName': roleName,
        'username': username,
      };
}

class RefreshTokenRequestModel {
  final String refreshToken;

  RefreshTokenRequestModel({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}
