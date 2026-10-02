enum FuelHistoryStatus { selesai, diverifikasi, menunggu }

class FuelHistoryEntity {
  final String id;
  final DateTime date;
  final String vehicleName;
  final String plateNumber;
  final String fuelType;
  final double liters;
  final double totalCost;
  final FuelHistoryStatus status;
  final bool hasReceipt;
  final String? tripCode;
  final double? odometer;
  final String? note;
  final String? receiptImageUrl;
  final int? vehicleId;

  const FuelHistoryEntity({
    required this.id,
    required this.date,
    required this.vehicleName,
    required this.plateNumber,
    required this.fuelType,
    required this.liters,
    required this.totalCost,
    required this.status,
    this.hasReceipt = false,
    this.tripCode,
    this.odometer,
    this.note,
    this.receiptImageUrl,
    this.vehicleId,
  });
}
