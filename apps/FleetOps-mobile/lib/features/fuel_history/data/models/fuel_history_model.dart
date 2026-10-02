import '../../domain/entities/fuel_history_entity.dart';

class FuelHistoryModel extends FuelHistoryEntity {
  const FuelHistoryModel({
    required super.id,
    required super.date,
    required super.vehicleName,
    required super.plateNumber,
    required super.fuelType,
    required super.liters,
    required super.totalCost,
    required super.status,
    super.hasReceipt,
    super.tripCode,
    super.odometer,
    super.note,
    super.receiptImageUrl,
    super.vehicleId,
  });

  // Untuk list: TripFuelRecordDTO (tidak ada imageUrlPath, odometerIsi, catatan)
  factory FuelHistoryModel.fromListJson(Map<String, dynamic> json) {
    final rawDate = json['waktuPengisian'] ?? json['createdAt'];
    final date = rawDate != null
        ? (DateTime.tryParse(rawDate.toString()) ?? DateTime.now()).toLocal()
        : DateTime.now();

    final vehicleId = json['vehicleId'] as int?;
    final vehicleName = json['vehicleName'] as String? ??
        (vehicleId != null ? 'Kendaraan #$vehicleId' : 'Kendaraan');
    final plateNumber = json['platNomor'] as String? ?? '-';
    final liters = (json['jmlLiter'] as num?)?.toDouble() ?? 0;
    final totalCost = (json['hargaTotal'] as num?)?.toDouble() ?? 0;

    return FuelHistoryModel(
      id: (json['fuelId'] ?? json['id'] ?? '').toString(),
      date: date,
      vehicleName: vehicleName,
      plateNumber: plateNumber,
      fuelType: json['fuelType'] as String? ?? '-',
      liters: liters,
      totalCost: totalCost,
      status: FuelHistoryStatus.selesai,
      vehicleId: vehicleId,
    );
  }

  // Untuk detail: TripFuelRecordDetailDTO (ada imageUrlPath, odometerIsi, catatan)
  factory FuelHistoryModel.fromDetailJson(Map<String, dynamic> json) {
    final rawDate = json['waktuPengisian'] ?? json['createdAt'];
    final date = rawDate != null
        ? (DateTime.tryParse(rawDate.toString()) ?? DateTime.now()).toLocal()
        : DateTime.now();

    final vehicleId = json['vehicleId'] as int?;
    final vehicleName = json['vehicleName'] as String? ??
        (vehicleId != null ? 'Kendaraan #$vehicleId' : 'Kendaraan');
    final plateNumber = json['platNomor'] as String? ?? '-';
    final liters = (json['jmlLiter'] as num?)?.toDouble() ?? 0;
    final totalCost = (json['hargaTotal'] as num?)?.toDouble() ?? 0;
    final imageUrl = json['imageUrlPath'] as String?;
    final note = json['catatan'] as String?;

    return FuelHistoryModel(
      id: (json['fuelId'] ?? json['id'] ?? '').toString(),
      date: date,
      vehicleName: vehicleName,
      plateNumber: plateNumber,
      fuelType: json['fuelType'] as String? ?? '-',
      liters: liters,
      totalCost: totalCost,
      status: FuelHistoryStatus.selesai,
      hasReceipt: imageUrl != null && imageUrl.isNotEmpty,
      odometer: (json['odometerIsi'] as num?)?.toDouble(),
      note: note?.isNotEmpty == true ? note : null,
      receiptImageUrl: imageUrl,
      vehicleId: vehicleId,
    );
  }
}
