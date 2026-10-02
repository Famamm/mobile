abstract class AdminDashboardEvent {}

class LoadAdminDashboard extends AdminDashboardEvent {
  final int? bulan;
  final int? tahun;
  final String? rangeArmada;
  final String? rangeBbm;

  LoadAdminDashboard({this.bulan, this.tahun, this.rangeArmada, this.rangeBbm});
}

/// Memuat ulang hanya chart aktivitas armada tanpa mengganggu chart BBM.
class LoadArmadaChart extends AdminDashboardEvent {
  final String rangeArmada;

  LoadArmadaChart({required this.rangeArmada});
}

/// Memuat ulang hanya chart biaya BBM tanpa mengganggu chart armada.
class LoadBbmChart extends AdminDashboardEvent {
  final String rangeBbm;

  LoadBbmChart({required this.rangeBbm});
}
