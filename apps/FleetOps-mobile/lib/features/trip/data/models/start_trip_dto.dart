class StartTripDTO {
  final int driverId;
  final int vehicleId;
  final String lokasiAwal;
  final String lokasiAkhir;
  final int odometerAwal;
  final double? kordAwalLatitude;
  final double? kordAwalLongitude;

  StartTripDTO({
    required this.driverId,
    required this.vehicleId,
    required this.lokasiAwal,
    required this.lokasiAkhir,
    required this.odometerAwal,
    this.kordAwalLatitude,
    this.kordAwalLongitude,
  });

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'vehicleId': vehicleId,
        'lokasiAwal': lokasiAwal,
        'lokasiAkhir': lokasiAkhir,
        'odometerAwal': odometerAwal,
        'kordAwalLatitude': kordAwalLatitude,
        'kordAwalLongitude': kordAwalLongitude,
      };
}
