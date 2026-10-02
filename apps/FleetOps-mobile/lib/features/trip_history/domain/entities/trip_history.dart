class TripHistory {
  final int tripId;
  final String id;
  final String startLocation;
  final String endLocation;
  final DateTime date;
  final DateTime? waktuSelesai;
  final String status;
  final String jarak;
  final String durasi;
  final String driverName;
  final String kecepatanRataRata;
  final String konsumsiBBM;
  final String note;
  final String? imageUrl;

  TripHistory({
    required this.tripId,
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.date,
    this.waktuSelesai,
    required this.status,
    required this.jarak,
    required this.durasi,
    required this.driverName,
    required this.kecepatanRataRata,
    required this.konsumsiBBM,
    required this.note,
    this.imageUrl,
  });
}
