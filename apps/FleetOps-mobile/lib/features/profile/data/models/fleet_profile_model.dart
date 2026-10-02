import '../../domain/entities/fleet_profile_entity.dart';

class FleetProfileModel extends FleetProfileEntity {
  const FleetProfileModel({
    required super.nama,
    required super.username,
    required super.email,
    super.alamat,
    super.photoUrl,
    super.role,
  });

  factory FleetProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final information = data['information'] as Map<String, dynamic>? ?? {};

    return FleetProfileModel(
      nama: (information['fullName'] ?? '') as String,
      username: (data['userName'] ?? '') as String,
      email: (information['email'] ?? '') as String,
      alamat: information['address'] as String?,
      photoUrl: information['photoUrl'] as String?,
      role: data['role'] as String?,
    );
  }
}
