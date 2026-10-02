class InspectionCheckItemEntity {
  final String name;
  final String status; // 'OK', 'MASALAH', 'N/A'
  final String? note;

  const InspectionCheckItemEntity({
    required this.name,
    required this.status,
    this.note,
  });
}

class InspectionCategoryEntity {
  final String name;
  final String iconAsset;
  final List<InspectionCheckItemEntity> items;

  const InspectionCategoryEntity({
    required this.name,
    required this.iconAsset,
    required this.items,
  });
}

class InspectionHistoryDetailEntity {
  final String id;
  final String vehicleName;
  final String plateNumber;
  final String status;
  final DateTime date;
  final int completionScore;
  final List<InspectionCategoryEntity> categories;
  final List<String> photoUrls;

  const InspectionHistoryDetailEntity({
    required this.id,
    required this.vehicleName,
    required this.plateNumber,
    required this.status,
    required this.date,
    required this.completionScore,
    required this.categories,
    this.photoUrls = const [],
  });
}
