import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userId,
    super.driverId,
    required super.fullName,
    required super.username,
    super.email,
    super.address,
    super.profilePhoto,
    required super.role,
    super.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? 0,
      driverId: json['driverId'],
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'],
      address: json['address'],
      profilePhoto: json['profilePhoto'],
      role: UserRole.fromString(json['roleName'] as String?),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'driverId': driverId,
        'fullName': fullName,
        'username': username,
        'email': email,
        'address': address,
        'profilePhoto': profilePhoto,
        'roleName': role.raw,
        'status': status,
      };
}