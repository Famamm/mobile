class FleetDashboardModel {
  final int totalDrivers;
  final int totalVehicles;
  final int activeVehicles;
  final int unsignedVehicles;
  final int unsignedDrivers;

  const FleetDashboardModel({
    required this.totalDrivers,
    required this.totalVehicles,
    required this.activeVehicles,
    required this.unsignedVehicles,
    required this.unsignedDrivers,
  });

  factory FleetDashboardModel.fromJson(Map<String, dynamic> json) {
    return FleetDashboardModel(
      totalDrivers: json['totalDriver'] ?? 0,
      totalVehicles: json['totalKendaraan'] ?? 0,
      activeVehicles: json['kendaraanAktif'] ?? 0,
      unsignedVehicles: json['kendaraanBelumAdaDriver'] ?? 0,
      unsignedDrivers: json['driverBelumDitugaskan'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalDrivers': totalDrivers,
        'totalVehicles': totalVehicles,
        'activeVehicles': activeVehicles,
        'unsignedVehicles': unsignedVehicles,
        'unsignedDrivers': unsignedDrivers,
      };
}