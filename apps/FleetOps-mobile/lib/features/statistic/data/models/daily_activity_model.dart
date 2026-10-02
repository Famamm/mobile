import '../../domain/entities/daily_activity_entity.dart';

class DailyActivityModel extends DailyActivityEntity {
  const DailyActivityModel({required super.date, required super.tripCount});

  factory DailyActivityModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['tanggal']?.toString();
    final date = DateTime.tryParse(rawDate ?? '');
    if (date == null) {
      throw const FormatException('Tanggal aktivitas armada tidak valid');
    }

    return DailyActivityModel(
      date: date,
      tripCount: (json['jumlahPerjalanan'] as num?)?.toInt() ?? 0,
    );
  }
}
