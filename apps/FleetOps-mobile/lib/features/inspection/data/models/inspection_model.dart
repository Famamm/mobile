import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_entity.dart';

class InspectionModel extends InspectionEntity {
  const InspectionModel({
    required super.id,
    required super.vehicleId,
    required super.driverId,
    required super.inspectionDate,
    required super.status,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['id'] ?? 0,
      vehicleId: json['vehicleId'] ?? 0,
      driverId: json['driverId'] ?? 0,
      inspectionDate: json['inspectionDate'] != null
          ? DateTime.parse(json['inspectionDate'] as String)
          : DateTime.now(),
      status: json['status'] is bool
          ? (json['status'] as bool ? 'completed' : 'pending')
          : json['status']?.toString() ?? 'pending',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'driverId': driverId,
      'inspectionDate': inspectionDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory InspectionModel.fromEntity(InspectionEntity entity) {
    return InspectionModel(
      id: entity.id,
      vehicleId: entity.vehicleId,
      driverId: entity.driverId,
      inspectionDate: entity.inspectionDate,
      status: entity.status,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
