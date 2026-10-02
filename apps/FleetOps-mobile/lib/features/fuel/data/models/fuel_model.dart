import '../../domain/entities/fuel_entity.dart';

class FuelModel extends FuelEntity {
  FuelModel({
    String? id,
    required String vehicleId,
    required String fuelType,
    required double fuelAmount,
    required double totalCost,
    required int odometerIsi,
    String? notes,
    String? imageUrlPath,
    required DateTime createdAt,
  }) : super(
          id: id,
          vehicleId: vehicleId,
          fuelType: fuelType,
          fuelAmount: fuelAmount,
          totalCost: totalCost,
          odometerIsi: odometerIsi,
          notes: notes,
          imageUrlPath: imageUrlPath,
          createdAt: createdAt,
        );

  factory FuelModel.fromJson(Map<String, dynamic> json) {
    return FuelModel(
      id: json['id']?.toString(),
      vehicleId: json['vehicleId']?.toString() ?? '',
      fuelType: json['fuelPrice']?['fuelType'] as String? ?? '',
      fuelAmount: (json['jmlLiter'] as num?)?.toDouble() ?? 0,
      totalCost: (json['hargaTotal'] as num?)?.toDouble() ?? 0,
      odometerIsi: (json['odometerIsi'] as num?)?.toInt() ?? 0,
      notes: json['catatan'] as String?,
      imageUrlPath: json['imageUrlPath'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
