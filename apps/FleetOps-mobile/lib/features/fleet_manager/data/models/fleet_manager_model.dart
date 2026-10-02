import '../../domain/entities/fleet_manager_entity.dart';

class FleetManagerModel extends FleetManagerEntity {
  const FleetManagerModel({
    required super.userId,
    required super.organizationId,
    required super.fullName,
    required super.address,
    required super.phoneNumber,
    required super.profilePhoto,
    required super.username,
    required super.status,
  });

  factory FleetManagerModel.fromJson(Map<String, dynamic> json) {
    return FleetManagerModel(
      userId: json['userId'] ?? json['id'] ?? 0,
      organizationId: json['organizationId'] ?? 0,
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
      username: json['username'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'organizationId': organizationId,
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
        'profilePhoto': profilePhoto,
        'username': username,
        'status': status,
      };
}