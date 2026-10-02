enum InspectionHistoryStatus { selesai, adaMasalah, diProses }

class InspectionProblemEntity {
  final String description;

  const InspectionProblemEntity({required this.description});
}

class InspectionHistoryEntity {
  final String id;
  final DateTime date;
  final String vehicleName;
  final String plateNumber;
  final int progressPercent;
  final InspectionHistoryStatus status;
  final List<InspectionProblemEntity> problems;

  const InspectionHistoryEntity({
    required this.id,
    required this.date,
    required this.vehicleName,
    required this.plateNumber,
    required this.progressPercent,
    required this.status,
    this.problems = const [],
  });

  bool get hasProblem => problems.isNotEmpty;
}
