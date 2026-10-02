/// Satu titik data aktivitas armada (jumlah perjalanan per tanggal/bulan).
class AdminFleetActivityDay {
  final DateTime tanggal;
  final int jumlahPerjalanan;

  const AdminFleetActivityDay({
    required this.tanggal,
    required this.jumlahPerjalanan,
  });
}

/// Satu titik data aktivitas BBM (liter & harga per tanggal/bulan).
class AdminBbmActivityDay {
  final DateTime tanggal;
  final double totalLiter;
  final int totalHarga;

  const AdminBbmActivityDay({
    required this.tanggal,
    required this.totalLiter,
    required this.totalHarga,
  });
}

/// Rincian jenis BBM yang dipakai (liter & harga per jenis).
class AdminJenisBbm {
  final String jenis;
  final double totalLiter;
  final int totalHarga;

  const AdminJenisBbm({
    required this.jenis,
    required this.totalLiter,
    required this.totalHarga,
  });
}

/// Ringkasan aktivitas armada pada rentang waktu terpilih.
class AdminRincianAktivitasArmada {
  final int totalJarak;
  final int totalDurasi;
  final double rataRataKecepatan;

  const AdminRincianAktivitasArmada({
    required this.totalJarak,
    required this.totalDurasi,
    required this.rataRataKecepatan,
  });
}

class AdminDashboard {
  final String organizationName;
  final int totalVehicles;
  final int totalDrivers;
  final int totalTrips;
  final int totalFleetManagers;

  final int bulan;
  final int tahun;

  /// Rentang chart aktivitas armada: "week", "month", atau "year".
  final String rangeArmada;

  /// Rentang chart biaya BBM: "week", "month", atau "year".
  final String rangeBbm;

  final List<AdminFleetActivityDay> aktivitasArmada;
  final int totalPerjalanan;
  final AdminRincianAktivitasArmada rincianAktivitasArmada;

  final List<AdminBbmActivityDay> aktivitasBbm;
  final double totalBbmLiter;
  final int totalHargaBbm;
  final List<String> jenisBbm;
  final List<AdminJenisBbm> rincianJenisBbm;

  const AdminDashboard({
    required this.organizationName,
    required this.totalVehicles,
    required this.totalDrivers,
    required this.totalTrips,
    required this.totalFleetManagers,
    required this.bulan,
    required this.tahun,
    required this.rangeArmada,
    required this.rangeBbm,
    required this.aktivitasArmada,
    required this.totalPerjalanan,
    required this.rincianAktivitasArmada,
    required this.aktivitasBbm,
    required this.totalBbmLiter,
    required this.totalHargaBbm,
    required this.jenisBbm,
    required this.rincianJenisBbm,
  });
}