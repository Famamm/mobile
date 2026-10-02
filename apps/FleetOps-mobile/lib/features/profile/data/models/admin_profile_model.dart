import '../../domain/entities/admin_profile_entity.dart';

class AdminProfileModel extends AdminProfileEntity {
  const AdminProfileModel({
    required super.nama,
    super.username,
    required super.email,
    super.alamat,
    super.photoUrl,
    super.role,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final information = data['information'] as Map<String, dynamic>? ?? {};

    return AdminProfileModel(
      nama: (information['fullName'] ?? '') as String,
      username: data['userName'] as String?,
      email: (information['email'] ?? '') as String,
      alamat: information['address'] as String?,
      photoUrl: information['photoUrl'] as String?,
      role: data['role'] as String?,
    );
  }
}
