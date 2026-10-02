int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

DateTime? _parseWaktuSelesai(dynamic v) {
  if (v == null) return null;
  final dt = DateTime.tryParse(v.toString());
  if (dt == null) return null;
  // DateTimeOffset.MinValue dari backend = 0001-01-01, abaikan
  if (dt.year < 2000) return null;
  return dt.toLocal();
}

class GetTripDTO {
  final int tripId;
  final int driverId;
  final int vehicleId;
  final String status;
  final String lokasiAwal;
  final String lokasiAkhir;
  final DateTime waktuMulai;
  final DateTime? waktuSelesai;
  final int jarakTempuh;
  final int durasi;
  final double? avgSpeed;
  final String? catatan;

  GetTripDTO({
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.status,
    required this.lokasiAwal,
    required this.lokasiAkhir,
    required this.waktuMulai,
    this.waktuSelesai,
    required this.jarakTempuh,
    required this.durasi,
    this.avgSpeed,
    this.catatan,
  });

  factory GetTripDTO.fromJson(Map<String, dynamic> json) {
    return GetTripDTO(
      tripId: _toInt(json['tripId'] ?? json['TripId'] ?? json['trip_id']),
      driverId: _toInt(json['driverId'] ?? json['DriverId']),
      vehicleId: _toInt(json['vehicleId'] ?? json['VehicleId']),
      status:
          json['status'] as String? ?? json['Status'] as String? ?? 'Unknown',
      lokasiAwal:
          json['lokasiAwal'] as String? ?? json['LokasiAwal'] as String? ?? '',
      lokasiAkhir: json['lokasiAkhir'] as String? ??
          json['LokasiAkhir'] as String? ??
          '',
      waktuMulai: json['waktuMulai'] != null
          ? DateTime.parse(json['waktuMulai'] as String).toLocal()
          : json['WaktuMulai'] != null
              ? DateTime.parse(json['WaktuMulai'] as String).toLocal()
              : DateTime.now(),
      waktuSelesai:
          _parseWaktuSelesai(json['waktuSelesai'] ?? json['WaktuSelesai']),
      jarakTempuh: _toInt(json['jarakTempuh'] ?? json['JarakTempuh']),
      durasi: _toInt(json['durasi'] ?? json['Durasi']),
      avgSpeed: (json['avgSpeed'] ?? json['AvgSpeed'] as num?)?.toDouble(),
      catatan: json['catatan'] as String? ?? json['Catatan'] as String?,
    );
  }
}
