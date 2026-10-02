import '../../domain/entities/admin_dashboard_entity.dart';

abstract class AdminDashboardState {}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboard dashboard;

  AdminDashboardLoaded({required this.dashboard});

  int get totalVehicles => dashboard.totalVehicles;
  int get totalDrivers => dashboard.totalDrivers;
  int get totalTrips => dashboard.totalTrips;
  int get totalFleetManagers => dashboard.totalFleetManagers;
  int get totalPerjalanan => dashboard.totalPerjalanan;
  String get rangeArmada => dashboard.rangeArmada;
  String get rangeBbm => dashboard.rangeBbm;
  List<AdminFleetActivityDay> get aktivitasArmada => dashboard.aktivitasArmada;
  AdminRincianAktivitasArmada get rincianAktivitasArmada =>
      dashboard.rincianAktivitasArmada;
  List<AdminBbmActivityDay> get aktivitasBbm => dashboard.aktivitasBbm;
  double get totalBbmLiter => dashboard.totalBbmLiter;
  int get totalHargaBbm => dashboard.totalHargaBbm;
  List<AdminJenisBbm> get rincianJenisBbm => dashboard.rincianJenisBbm;
}

class AdminDashboardError extends AdminDashboardState {
  final String message;
  AdminDashboardError(this.message);
}
