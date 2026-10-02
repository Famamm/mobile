enum UserRole {
  admin('Admin'),
  fleetManager('FleetManager'),
  driver('Driver'),
  unknown('Unknown');

  final String raw;
  const UserRole(this.raw);

  static UserRole fromString(String? value) {
    switch (value) {
      case 'Admin':
        return UserRole.admin;
      case 'FleetManager':
        return UserRole.fleetManager;
      case 'Driver':
        return UserRole.driver;
      default:
        return UserRole.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.fleetManager:
        return 'Fleet Manager';
      case UserRole.driver:
        return 'Driver';
      case UserRole.unknown:
        return 'Tidak diketahui';
    }
  }
}

class User {
  final int userId;
  final int? driverId;
  final String fullName;
  final String username;
  final String? email;
  final String? address;
  final String? profilePhoto;
  final UserRole role;
  final String? status;

  const User({
    required this.userId,
    this.driverId,
    required this.fullName,
    required this.username,
    this.email,
    this.address,
    this.profilePhoto,
    required this.role,
    this.status,
  });

  bool get isDriver => role == UserRole.driver;
  bool get isFleetManager => role == UserRole.fleetManager;
  bool get isAdmin => role == UserRole.admin;
  bool get isActive => status?.toLowerCase() == 'active';
}