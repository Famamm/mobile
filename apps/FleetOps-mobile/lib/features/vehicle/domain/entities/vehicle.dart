class Vehicle {
  final int vehicleId;
  final int driverId;
  final int? organizationId;
  final String vehicleName;
  final String platNomor;
  final int tahunPembuatan;
  final int odometer;
  final String tipe;
  final String status;
  final int muatanMax;
  final String tipeBensin;
  final String? imageUrl;

  Vehicle({
    required this.vehicleId,
    required this.driverId,
    this.organizationId,
    required this.vehicleName,
    required this.platNomor,
    required this.tahunPembuatan,
    required this.odometer,
    required this.tipe,
    required this.status,
    required this.muatanMax,
    required this.tipeBensin,
    this.imageUrl,
  });
}
