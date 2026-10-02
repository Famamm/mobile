class GetActiveTripDTO {
  final int tripId;
  final int driverId;
  final int vehicleId;
  final String vehicleName;
  final String platNomor;
  final String lokasiAwal;
  final String? lokasiAkhir;
  final DateTime waktuMulai;
  final int odometerAwal;
  final String status;
  final int durasiDetik;

  GetActiveTripDTO({
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.vehicleName,
    required this.platNomor,
    required this.lokasiAwal,
    this.lokasiAkhir,
    required this.waktuMulai,
    required this.odometerAwal,
    required this.status,
    required this.durasiDetik,
  });

  factory GetActiveTripDTO.fromJson(Map<String, dynamic> json) {
    return GetActiveTripDTO(
      tripId: (json['tripId'] as num).toInt(),
      driverId: (json['driverId'] as num).toInt(),
      vehicleId: (json['vehicleId'] as num).toInt(),
      vehicleName: json['vehicleName'] as String? ?? '',
      platNomor: json['platNomor'] as String? ?? '',
      lokasiAwal: json['lokasiAwal'] as String? ?? '',
      lokasiAkhir: json['lokasiAkhir'] as String?,
      waktuMulai: DateTime.parse(json['waktuMulai'] as String).toLocal(),
      odometerAwal: (json['odometerAwal'] as num).toInt(),
      status: json['status'] as String? ?? 'Ongoing',
      durasiDetik: (json['durasiDetik'] as num).toInt(),
    );
  }
}
