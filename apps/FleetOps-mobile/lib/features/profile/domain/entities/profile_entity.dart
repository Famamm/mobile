import 'package:equatable/equatable.dart';

class DriverVehicleItem extends Equatable {
  final int vehicleId;
  final String vehicleName;
  final String platNomor;
  final String tipe;
  final String status;
  final String? imageUrl;
  final int odometer;
  final String tipeBensin;

  const DriverVehicleItem({
    required this.vehicleId,
    required this.vehicleName,
    required this.platNomor,
    required this.tipe,
    required this.status,
    this.imageUrl,
    this.odometer = 0,
    this.tipeBensin = '',
  });

  @override
  List<Object?> get props => [
        vehicleId,
        vehicleName,
        platNomor,
        tipe,
        status,
        imageUrl,
        odometer,
        tipeBensin
      ];
}

class DriverDocumentItem extends Equatable {
  final String jenisLisensi;
  final String? fotoLisensi;
  final DateTime tanggalBerlaku;
  final String status;

  const DriverDocumentItem({
    required this.jenisLisensi,
    this.fotoLisensi,
    required this.tanggalBerlaku,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [jenisLisensi, fotoLisensi, tanggalBerlaku, status];
}

class ProfileEntity extends Equatable {
  final int driverId;
  final String namaDriver;
  final String email;
  final String? photoUrl;
  final double totalJarak;
  final int totalTrip;
  final DriverVehicleItem? kendaraanAktif;
  final List<DriverVehicleItem> kendaraanTersedia;
  final DriverDocumentItem? dokumen;

  const ProfileEntity({
    required this.driverId,
    required this.namaDriver,
    required this.email,
    this.photoUrl,
    required this.totalJarak,
    required this.totalTrip,
    this.kendaraanAktif,
    required this.kendaraanTersedia,
    this.dokumen,
  });

  @override
  List<Object?> get props => [
        driverId,
        namaDriver,
        email,
        photoUrl,
        totalJarak,
        totalTrip,
        kendaraanAktif,
        kendaraanTersedia,
        dokumen,
      ];
}
