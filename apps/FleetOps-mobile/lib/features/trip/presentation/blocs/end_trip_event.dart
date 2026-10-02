import 'dart:io';

abstract class EndTripEvent {}

class EndTripSubmitted extends EndTripEvent {
  final int tripId; // ← Tambah
  final int driverId; // ← Tambah
  final int vehicleId; // ← Tambah
  final String startLocation;
  final String endLocation;
  final File? dokumentasiFoto;
  final int odometerAkhir;
  final int odometerAwal;
  final double kecepatanRataRata;
  final Duration durasiPerjalanan;
  final String note;
  final double? kordAkhirLatitude;
  final double? kordAkhirLongitude;

  EndTripSubmitted({
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.startLocation,
    required this.endLocation,
    this.dokumentasiFoto,
    required this.odometerAkhir,
    required this.odometerAwal,
    required this.durasiPerjalanan,
    required this.kecepatanRataRata,
    required this.note,
    this.kordAkhirLatitude,
    this.kordAkhirLongitude,
  });
}
