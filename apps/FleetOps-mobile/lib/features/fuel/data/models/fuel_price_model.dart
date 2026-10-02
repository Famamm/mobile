class FuelPriceModel {
  final int id;
  final String fuelType;
  final int pricePerLiter;

  FuelPriceModel({
    required this.id,
    required this.fuelType,
    required this.pricePerLiter,
  });

  factory FuelPriceModel.fromJson(Map<String, dynamic> json) {
    return FuelPriceModel(
      id: (json['id'] as num).toInt(),
      fuelType: json['fuelType'] as String? ?? '',
      pricePerLiter: (json['pricePerLiter'] as num).toInt(),
    );
  }
}
