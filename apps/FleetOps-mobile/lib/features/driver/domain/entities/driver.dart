class Driver {
  final int driverId;
  final String name;
  final String? email;
  final String? password;
  final String phone;
  final String address;
  final String role;
  final String status;
  final String joinDate;
  final String licenseType;
  final String licenseExpiry;
  final String? licenseImageUrl;
  final String? profileImageUrl;
  final String vehicleAssigned;
  final int totalTrips;
  final double rating;

  Driver({
    required this.driverId,
    required this.name,
    this.email,
    this.password,
    required this.phone,
    required this.address,
    required this.role,
    required this.status,
    required this.joinDate,
    required this.licenseType,
    required this.licenseExpiry,
    this.licenseImageUrl,
    this.profileImageUrl,
    required this.vehicleAssigned,
    required this.totalTrips,
    required this.rating,
  });
}
