import '../../domain/entities/inspection_history_entity.dart';

class InspectionProblemModel extends InspectionProblemEntity {
  const InspectionProblemModel({required super.description});

  factory InspectionProblemModel.fromJson(Map<String, dynamic> json) {
    return InspectionProblemModel(
      description: json['description'] as String? ?? '',
    );
  }
}

class InspectionHistoryModel extends InspectionHistoryEntity {
  const InspectionHistoryModel({
    required super.id,
    required super.date,
    required super.vehicleName,
    required super.plateNumber,
    required super.progressPercent,
    required super.status,
    super.problems,
  });

  factory InspectionHistoryModel.fromJson(Map<String, dynamic> json) {
    // status: boolean true = selesai, false = ada masalah
    final rawStatus = json['status'];
    final status = rawStatus == true
        ? InspectionHistoryStatus.selesai
        : InspectionHistoryStatus.adaMasalah;

    // tanggal dari createdAt
    final rawDate = json['createdAt'] ?? json['inspectionDate'] ?? json['date'];
    final date = rawDate != null
        ? (DateTime.tryParse(rawDate.toString()) ?? DateTime.now()).toLocal()
        : DateTime.now();

    // nama kendaraan & plat dari nested vehicle jika ada
    final vehicle = json['vehicle'] as Map<String, dynamic>?;
    final vehicleName = vehicle?['name'] as String? ??
        vehicle?['vehicleName'] as String? ??
        json['vehicleName'] as String? ??
        'Kendaraan #${json['vehicleId']}';
    final plateNumber = vehicle?['platNomor'] as String? ??
        vehicle?['licensePlate'] as String? ??
        json['platNomor'] as String? ??
        '-';

    // progress dari results: hitung berapa yang condition == 0 (OK)
    final results = json['results'] as List<dynamic>? ?? [];
    final total = results.length;
    final ok = results.where((r) => (r as Map)['condition'] == 0).length;
    final progressPercent = total == 0 ? 100 : ((ok / total) * 100).round();

    // problems: item yang condition != 0
    final problems =
        results.where((r) => (r as Map)['condition'] != 0).map((r) {
      final m = r as Map<String, dynamic>;
      final itemName = m['itemName'] as String? ?? 'Item';
      final note = m['note'] as String?;
      final desc = note != null && note.isNotEmpty
          ? '$itemName: $note'
          : '$itemName bermasalah';
      return InspectionProblemModel(description: desc);
    }).toList();

    return InspectionHistoryModel(
      id: (json['id'] ?? '').toString(),
      date: date,
      vehicleName: vehicleName,
      plateNumber: plateNumber,
      progressPercent: progressPercent,
      status: status,
      problems: problems,
    );
  }
}
