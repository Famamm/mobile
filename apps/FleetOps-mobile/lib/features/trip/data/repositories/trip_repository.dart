import 'dart:io';

abstract class TripRepository {
  Future<String> startTrip({
    required String titikAwal,
    required String titikAkhir,
    required double odometerAwal,
  });

  Future<String> endTrip({
    required String startLocation,
    required String endLocation,
    required File dokumentasiFoto,
    required double odometerAwal,
    required double odometerAkhir,
    required double kecepatanRataRata,
    required Duration durasiPerjalanan,
    required String note,
  });
}
