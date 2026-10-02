import '../../domain/entities/driver.dart';

class DriverModel extends Driver {
  DriverModel({
    required super.driverId,
    required super.name,
    required super.phone,
    required super.address,
    required super.role,
    required super.status,
    required super.joinDate,
    required super.licenseType,
    required super.licenseExpiry,
    super.licenseImageUrl,
    super.profileImageUrl,
    required super.vehicleAssigned,
    required super.totalTrips,
    required super.rating,
  });

  static String _parseDate(String value) {
    if (value.isEmpty) return value;
    try {
      return DateTime.parse(value).toLocal().toString().split(' ').first;
    } catch (_) {
      return value;
    }
  }

  // Endpoint admin memakai `fullName`, sedangkan endpoint lain di backend yang
  // sama memakai `namaDriver`, `driverName`, atau objek `user` bersarang.
  static String _parseName(Map<String, dynamic> json) {
    final user = json['user'];
    final candidates = [
      json['fullName'],
      json['name'],
      json['namaDriver'],
      json['driverName'],
      if (user is Map<String, dynamic>) user['fullName'],
      json['username'],
      json['userName'],
    ];
    for (final candidate in candidates) {
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return '';
  }

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        driverId: json['id'] as int? ?? json['driverId'] as int? ?? 0,
        name: _parseName(json),
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        role: json['role'] as String? ?? 'Driver',
        status: json['status'] as String? ?? 'Active',
        joinDate:
            json['joinDate'] as String? ?? json['createdAt'] as String? ?? '',
        licenseType: json['jenisLisensi'] as String? ??
            json['licenseType'] as String? ??
            '',
        licenseExpiry: _parseDate(json['tanggalBerlaku'] as String? ??
            json['licenseExpiry'] as String? ??
            ''),
        licenseImageUrl: json['fotoLisensi'] as String? ??
            json['licenseImageUrl'] as String?,
        profileImageUrl: json['profilePhoto'] as String? ??
            json['profileImageUrl'] as String?,
        vehicleAssigned: json['vehicleAssigned'] as String? ?? '-',
        totalTrips:
            json['totalTrip'] as int? ?? json['totalTrips'] as int? ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      );
}
