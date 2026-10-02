import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String driverName;
  final int totalJarak;
  final int tripSelesai;
  final String platNomor;
  final String vehicleName;
  final String vehicleStatus;

  const DashboardEntity({
    required this.driverName,
    required this.totalJarak,
    required this.tripSelesai,
    required this.platNomor,
    required this.vehicleName,
    required this.vehicleStatus,
  });

  @override
  List<Object> get props => [
        driverName,
        totalJarak,
        tripSelesai,
        platNomor,
        vehicleName,
        vehicleStatus,
      ];
}
