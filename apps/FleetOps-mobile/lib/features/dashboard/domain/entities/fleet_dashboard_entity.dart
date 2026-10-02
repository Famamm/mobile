class FleetDashboardEntity {
  final int totalDrivers;
  final int totalVehicles;
  final int activeVehicles;
  final int unsignedVehicles;
  final int unsignedDrivers;

  FleetDashboardEntity({
    required this.totalDrivers,
    required this.totalVehicles,
    required this.activeVehicles,
    required this.unsignedVehicles,
    required this.unsignedDrivers,
  });
}
