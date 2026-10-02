class TripDetailDTO {
  final double jarak;
  final double avgSpeed;
  final int waktu; // detik
  final String? imageUrl;

  TripDetailDTO({
    required this.jarak,
    required this.avgSpeed,
    required this.waktu,
    this.imageUrl,
  });

  factory TripDetailDTO.fromJson(Map<String, dynamic> json) => TripDetailDTO(
        jarak: (json['jarak'] as num?)?.toDouble() ?? 0,
        avgSpeed: (json['avgSpeed'] as num?)?.toDouble() ?? 0,
        waktu: (json['waktu'] as num?)?.toInt() ?? 0,
        imageUrl: json['imageUrl'] as String?,
      );
}

class GetDetailTripDTO {
  final int tripId;
  final int driverId;
  final int vehicleId;
  final String lokasiAwal;
  final String lokasiAkhir;
  final DateTime waktuMulai;
  final DateTime? waktuSelesai;
  final String? catatan;
  final List<TripDetailDTO> details;

  GetDetailTripDTO({
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.lokasiAwal,
    required this.lokasiAkhir,
    required this.waktuMulai,
    this.waktuSelesai,
    this.catatan,
    required this.details,
  });

  factory GetDetailTripDTO.fromJson(Map<String, dynamic> json) =>
      GetDetailTripDTO(
        tripId: (json['tripId'] as num).toInt(),
        driverId: (json['driverId'] as num).toInt(),
        vehicleId: (json['vehicleId'] as num).toInt(),
        lokasiAwal: json['lokasiAwal'] as String? ?? '',
        lokasiAkhir: json['lokasiAkhir'] as String? ?? '',
        waktuMulai: DateTime.parse(json['waktuMulai'] as String).toLocal(),
        waktuSelesai: json['waktuSelesai'] != null
            ? DateTime.parse(json['waktuSelesai'] as String).toLocal()
            : null,
        catatan: json['catatan'] as String?,
        details: (json['details'] as List<dynamic>? ?? [])
            .map((e) => TripDetailDTO.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
