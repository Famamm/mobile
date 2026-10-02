import '../../domain/entities/inspection_history_summary_entity.dart';

class InspectionHistorySummaryModel extends InspectionHistorySummaryEntity {
  const InspectionHistorySummaryModel({
    required super.totalInspeksi,
    required super.kelengkapanInspeksiPercent,
  });

  factory InspectionHistorySummaryModel.fromJson(Map<String, dynamic> json) {
    return InspectionHistorySummaryModel(
      totalInspeksi: json['totalInspeksi'] as int,
      kelengkapanInspeksiPercent: json['kelengkapanInspeksiPercent'] as int,
    );
  }
}
