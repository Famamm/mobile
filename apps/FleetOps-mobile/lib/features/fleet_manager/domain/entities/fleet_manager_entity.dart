class FleetManagerEntity {
  final int userId;
  final int organizationId;
  final String fullName;
  final String address;
  final String phoneNumber;
  final String profilePhoto;
  final String username;
  final String? status;

  const FleetManagerEntity({
    required this.userId,
    required this.organizationId,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    required this.profilePhoto,
    required this.username,
    this.status,
  });

  FleetManagerEntity copyWith({
    int? userId,
    int? organizationId,
    String? fullName,
    String? address,
    String? phoneNumber,
    String? profilePhoto,
    String? username,
    String? status,
  }) {
    return FleetManagerEntity(
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      username: username ?? this.username,
      status: status ?? this.status,
    );
  }
}