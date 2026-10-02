import 'dart:io';

class StopTripDTO {
  final int driverId;
  final int vehicleId;
  final String lokasiAkhir;
  final int? odometerAkhir;
  final double? kordAkhirLatitude;
  final double? kordAkhirLongitude;
  final String catatan;
  final File? dokumentasiFoto;

  StopTripDTO({
    required this.driverId,
    required this.vehicleId,
    required this.lokasiAkhir,
    this.odometerAkhir,
    this.kordAkhirLatitude,
    this.kordAkhirLongitude,
    required this.catatan,
    this.dokumentasiFoto,
  });

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'vehicleId': vehicleId,
        'lokasiAkhir': lokasiAkhir,
        'odometerAkhir': odometerAkhir,
        'kordAkhirLatitude': kordAkhirLatitude,
        'kordAkhirLongitude': kordAkhirLongitude,
        'catatan': catatan,
      };
}
