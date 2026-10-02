class CreateInspectionDTO {
  final int vehicleId;
  final int driverId;
  final DateTime inspectionDate;
  final String status;
  final String? notes;
  final List<String>? photoPaths; // Paths untuk file yang akan di-upload

  CreateInspectionDTO({
    required this.vehicleId,
    required this.driverId,
    required this.inspectionDate,
    this.status = 'pending',
    this.notes,
    this.photoPaths,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'driverId': driverId,
      'inspectionDate': inspectionDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}
