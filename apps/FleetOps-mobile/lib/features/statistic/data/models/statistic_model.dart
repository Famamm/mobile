import '../../domain/entities/statistic_entity.dart';
import 'daily_activity_model.dart';

class StatisticModel extends StatisticEntity {
  const StatisticModel({
    required super.month,
    required super.year,
    required super.totalVehicles,
    required super.activeVehicles,
    required super.vehiclesInService,
    required super.inactiveVehicles,
    required super.totalTrips,
    required super.totalDistance,
    required super.totalFuel,
    required super.totalCost,
    required super.fuelTypes,
    required super.dailyActivity,
  });

  factory StatisticModel.fromJson(Map<String, dynamic> json) {
    final activity = (json['aktivitasArmada'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(DailyActivityModel.fromJson)
        .toList();
    final fuelTypes = (json['jenisBbm'] as List<dynamic>? ?? [])
        .map((item) => item.toString())
        .toList();

    return StatisticModel(
      month: (json['bulan'] as num?)?.toInt() ?? 0,
      year: (json['tahun'] as num?)?.toInt() ?? 0,
      totalVehicles: (json['totalKendaraan'] as num?)?.toInt() ?? 0,
      activeVehicles: (json['kendaraanAktif'] as num?)?.toInt() ?? 0,
      vehiclesInService: (json['kendaraanDalamServis'] as num?)?.toInt() ?? 0,
      inactiveVehicles: (json['kendaraanTidakAktif'] as num?)?.toInt() ?? 0,
      totalTrips: (json['totalPerjalanan'] as num?)?.toInt() ?? 0,
      totalDistance: (json['totalJarak'] as num?)?.toDouble() ?? 0,
      totalFuel: (json['totalBbmLiter'] as num?)?.toDouble() ?? 0,
      totalCost: (json['totalHargaBbm'] as num?)?.toInt() ?? 0,
      fuelTypes: fuelTypes,
      dailyActivity: activity,
    );
  }
}
