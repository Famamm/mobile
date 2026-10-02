import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.driverName,
    required super.totalJarak,
    required super.tripSelesai,
    required super.platNomor,
    required super.vehicleName,
    required super.vehicleStatus,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      driverName: json['driverName']?.toString() ?? '',
      totalJarak: (json['totalJarak'] as num?)?.toInt() ?? 0,
      tripSelesai: (json['tripSelesai'] as num?)?.toInt() ?? 0,
      platNomor: json['platNomor']?.toString() ?? '-',
      vehicleName: json['vehicleName']?.toString() ?? '-',
      vehicleStatus: json['vehicleStatus']?.toString() ?? 'unknown',
    );
  }
}
