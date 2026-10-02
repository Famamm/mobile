import '../../domain/entities/profile_entity.dart';

class DriverVehicleItemModel extends DriverVehicleItem {
  const DriverVehicleItemModel({
    required super.vehicleId,
    required super.vehicleName,
    required super.platNomor,
    required super.tipe,
    required super.status,
    super.imageUrl,
    super.odometer,
    super.tipeBensin,
  });

  factory DriverVehicleItemModel.fromJson(Map<String, dynamic> json) {
    final tipeBensinRaw = json['tipeBensin'] ?? json['TipeBensin'];
    String tipeBensin = '';
    if (tipeBensinRaw is String) {
      tipeBensin = tipeBensinRaw;
    } else if (tipeBensinRaw is int) {
      tipeBensin = tipeBensinRaw == 0 ? 'Diesel' : 'Bensin';
    }
    return DriverVehicleItemModel(
      vehicleId: (json['vehicleId'] ?? json['VehicleId']) as int,
      vehicleName: (json['vehicleName'] ?? json['VehicleName']) as String,
      platNomor: (json['platNomor'] ?? json['PlatNomor']) as String,
      tipe: (json['tipe'] ?? json['Tipe']) as String,
      status: (json['status'] ?? json['Status']) as String,
      imageUrl: (json['imageUrl'] ?? json['ImageUrl']) as String?,
      odometer: ((json['odometer'] ?? json['Odometer']) as num?)?.toInt() ?? 0,
      tipeBensin: tipeBensin,
    );
  }
}

class DriverDocumentItemModel extends DriverDocumentItem {
  const DriverDocumentItemModel({
    required super.jenisLisensi,
    super.fotoLisensi,
    required super.tanggalBerlaku,
    required super.status,
  });

  factory DriverDocumentItemModel.fromJson(Map<String, dynamic> json) {
    return DriverDocumentItemModel(
      jenisLisensi: (json['jenisLisensi'] ?? json['JenisLisensi']) as String,
      fotoLisensi: (json['fotoLisensi'] ?? json['FotoLisensi']) as String?,
      tanggalBerlaku: DateTime.parse(
        (json['tanggalBerlaku'] ?? json['TanggalBerlaku']) as String,
      ),
      status: (json['status'] ?? json['Status']) as String,
    );
  }
}

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.driverId,
    required super.namaDriver,
    required super.email,
    super.photoUrl,
    required super.totalJarak,
    required super.totalTrip,
    required super.kendaraanTersedia,
    super.kendaraanAktif,
    super.dokumen,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final statsRaw =
        (data['statistics'] ?? data['Statistics']) as Map<String, dynamic>;
    final stats = statsRaw;

    final kendaraanAktifRaw = data['kendaraanAktif'] ?? data['KendaraanAktif'];
    DriverVehicleItem? kendaraanAktif;
    if (kendaraanAktifRaw != null) {
      kendaraanAktif = DriverVehicleItemModel.fromJson(
        kendaraanAktifRaw as Map<String, dynamic>,
      );
    }

    final kendaraanTersediaRaw = (data['kendaraanTersedia'] ??
            data['kendaraanTersedia']) as List<dynamic>? ??
        [];
    final kendaraanTersedia = kendaraanTersediaRaw
        .map((v) => DriverVehicleItemModel.fromJson(v as Map<String, dynamic>))
        .toList();

    final dokumenRaw = data['dokumen'] ?? data['Dokumen'];
    DriverDocumentItem? dokumen;
    if (dokumenRaw != null) {
      dokumen = DriverDocumentItemModel.fromJson(
        dokumenRaw as Map<String, dynamic>,
      );
    }

    return ProfileModel(
      driverId: (data['driverId'] ?? data['DriverId']) as int,
      namaDriver: (data['namaDriver'] ?? data['NamaDriver']) as String,
      email: (data['email'] ?? data['Email']) as String,
      photoUrl: (data['photoUrl'] ?? data['PhotoUrl']) as String?,
      totalJarak:
          ((stats['totalJarak'] ?? stats['TotalJarak']) as num).toDouble(),
      totalTrip: (stats['totalTrip'] ?? stats['TotalTrip']) as int,
      kendaraanAktif: kendaraanAktif,
      kendaraanTersedia: kendaraanTersedia,
      dokumen: dokumen,
    );
  }
}
