class FuelEntity {
  final String? id;
  final String vehicleId;
  final String fuelType;
  final double fuelAmount;
  final double totalCost;
  final int odometerIsi;
  final String? notes;
  final String? imageUrlPath;
  final DateTime createdAt;

  FuelEntity({
    this.id,
    required this.vehicleId,
    required this.fuelType,
    required this.fuelAmount,
    required this.totalCost,
    required this.odometerIsi,
    this.notes,
    this.imageUrlPath,
    required this.createdAt,
  });
}
