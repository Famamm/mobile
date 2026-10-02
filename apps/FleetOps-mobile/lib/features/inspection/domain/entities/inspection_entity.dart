import 'package:equatable/equatable.dart';

class InspectionEntity extends Equatable {
  final int id;
  final int vehicleId;
  final int driverId;
  final DateTime inspectionDate;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InspectionEntity({
    required this.id,
    required this.vehicleId,
    required this.driverId,
    required this.inspectionDate,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        vehicleId,
        driverId,
        inspectionDate,
        status,
        notes,
        createdAt,
        updatedAt,
      ];
}
