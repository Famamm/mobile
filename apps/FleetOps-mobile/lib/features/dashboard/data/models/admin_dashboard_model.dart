import '../../domain/entities/admin_dashboard_entity.dart';

class AdminFleetActivityDayModel extends AdminFleetActivityDay {
  const AdminFleetActivityDayModel({
    required super.tanggal,
    required super.jumlahPerjalanan,
  });

  factory AdminFleetActivityDayModel.fromJson(Map<String, dynamic> json) {
    return AdminFleetActivityDayModel(
      tanggal: _parseDate(json['tanggal'] ?? json['Tanggal']),
      jumlahPerjalanan:
          ((json['jumlahPerjalanan'] ?? json['JumlahPerjalanan']) as num?)
                  ?.toInt() ??
              0,
    );
  }
}

class AdminBbmActivityDayModel extends AdminBbmActivityDay {
  const AdminBbmActivityDayModel({
    required super.tanggal,
    required super.totalLiter,
    required super.totalHarga,
  });

  factory AdminBbmActivityDayModel.fromJson(Map<String, dynamic> json) {
    return AdminBbmActivityDayModel(
      tanggal: _parseDate(json['tanggal'] ?? json['Tanggal']),
      totalLiter:
          ((json['totalLiter'] ?? json['TotalLiter']) as num?)?.toDouble() ?? 0,
      totalHarga:
          ((json['totalHarga'] ?? json['TotalHarga']) as num?)?.toInt() ?? 0,
    );
  }
}

class AdminJenisBbmModel extends AdminJenisBbm {
  const AdminJenisBbmModel({
    required super.jenis,
    required super.totalLiter,
    required super.totalHarga,
  });

  factory AdminJenisBbmModel.fromJson(Map<String, dynamic> json) {
    return AdminJenisBbmModel(
      jenis: (json['jenis'] ?? json['Jenis'] ?? '') as String,
      totalLiter:
          ((json['totalLiter'] ?? json['TotalLiter']) as num?)?.toDouble() ?? 0,
      totalHarga:
          ((json['totalHarga'] ?? json['TotalHarga']) as num?)?.toInt() ?? 0,
    );
  }
}

class AdminRincianAktivitasArmadaModel extends AdminRincianAktivitasArmada {
  const AdminRincianAktivitasArmadaModel({
    required super.totalJarak,
    required super.totalDurasi,
    required super.rataRataKecepatan,
  });

  factory AdminRincianAktivitasArmadaModel.fromJson(Map<String, dynamic> json) {
    return AdminRincianAktivitasArmadaModel(
      totalJarak:
          ((json['totalJarak'] ?? json['TotalJarak']) as num?)?.toInt() ?? 0,
      totalDurasi:
          ((json['totalDurasi'] ?? json['TotalDurasi']) as num?)?.toInt() ?? 0,
      rataRataKecepatan:
          ((json['rataRataKecepatan'] ?? json['RataRataKecepatan']) as num?)
                  ?.toDouble() ??
              0,
    );
  }
}

class AdminDashboardModel extends AdminDashboard {
  const AdminDashboardModel({
    required super.organizationName,
    required super.totalVehicles,
    required super.totalDrivers,
    required super.totalTrips,
    required super.totalFleetManagers,
    required super.bulan,
    required super.tahun,
    required super.rangeArmada,
    required super.rangeBbm,
    required super.aktivitasArmada,
    required super.totalPerjalanan,
    required super.rincianAktivitasArmada,
    required super.aktivitasBbm,
    required super.totalBbmLiter,
    required super.totalHargaBbm,
    required super.jenisBbm,
    required super.rincianJenisBbm,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final aktivitasArmadaRaw =
        (json['aktivitasArmada'] ?? json['AktivitasArmada']) as List<dynamic>? ??
            [];
    final aktivitasBbmRaw =
        (json['aktivitasBbm'] ?? json['AktivitasBbm']) as List<dynamic>? ?? [];
    final jenisBbmRaw =
        (json['jenisBbm'] ?? json['JenisBbm']) as List<dynamic>? ?? [];
    final rincianJenisBbmRaw =
        (json['rincianJenisBbm'] ?? json['RincianJenisBbm']) as List<dynamic>? ??
            [];
    final rincianArmadaRaw =
        (json['rincianAktivitasArmada'] ?? json['RincianAktivitasArmada'])
            as Map<String, dynamic>?;

    return AdminDashboardModel(
      organizationName:
          (json['organizationName'] ?? json['OrganizationName'] ?? '') as String,
      totalVehicles:
          ((json['totalVehicles'] ?? json['TotalVehicles']) as num?)?.toInt() ??
              0,
      totalDrivers:
          ((json['totalDrivers'] ?? json['TotalDrivers']) as num?)?.toInt() ?? 0,
      totalTrips:
          ((json['totalTrips'] ?? json['TotalTrips']) as num?)?.toInt() ?? 0,
      totalFleetManagers:
          ((json['totalFleetManagers'] ?? json['TotalFleetManagers']) as num?)
                  ?.toInt() ??
              0,
      bulan: ((json['bulan'] ?? json['Bulan']) as num?)?.toInt() ?? 0,
      tahun: ((json['tahun'] ?? json['Tahun']) as num?)?.toInt() ?? 0,
      rangeArmada:
          (json['rangeArmada'] ?? json['RangeArmada'] ?? 'week') as String,
      rangeBbm: (json['rangeBbm'] ?? json['RangeBbm'] ?? 'week') as String,
      aktivitasArmada: aktivitasArmadaRaw
          .map((e) =>
              AdminFleetActivityDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPerjalanan:
          ((json['totalPerjalanan'] ?? json['TotalPerjalanan']) as num?)
                  ?.toInt() ??
              0,
      rincianAktivitasArmada: rincianArmadaRaw == null
          ? const AdminRincianAktivitasArmadaModel(
              totalJarak: 0,
              totalDurasi: 0,
              rataRataKecepatan: 0,
            )
          : AdminRincianAktivitasArmadaModel.fromJson(rincianArmadaRaw),
      aktivitasBbm: aktivitasBbmRaw
          .map((e) => AdminBbmActivityDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalBbmLiter:
          ((json['totalBbmLiter'] ?? json['TotalBbmLiter']) as num?)
                  ?.toDouble() ??
              0,
      totalHargaBbm:
          ((json['totalHargaBbm'] ?? json['TotalHargaBbm']) as num?)?.toInt() ??
              0,
      jenisBbm: jenisBbmRaw.map((e) => e.toString()).toList(),
      rincianJenisBbm: rincianJenisBbmRaw
          .map((e) => AdminJenisBbmModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

DateTime _parseDate(dynamic value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}
