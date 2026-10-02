import 'package:equatable/equatable.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';

abstract class InspectionEvent extends Equatable {
  const InspectionEvent();

  @override
  List<Object?> get props => [];
}

class SubmitInspectionEvent extends InspectionEvent {
  final int vehicleId;
  final int driverId;
  final List<InspectionItemEntity> items;

  const SubmitInspectionEvent({
    required this.vehicleId,
    required this.driverId,
    required this.items,
  });

  @override
  List<Object?> get props => [vehicleId, driverId, items];
}

class UpdateInspectionEvent extends InspectionEvent {
  final int inspectionId;
  final int vehicleId;
  final int driverId;
  final List<InspectionItemEntity> items;

  const UpdateInspectionEvent({
    required this.inspectionId,
    required this.vehicleId,
    required this.driverId,
    required this.items,
  });

  @override
  List<Object?> get props => [inspectionId, vehicleId, driverId, items];
}

class ResetInspectionEvent extends InspectionEvent {
  const ResetInspectionEvent();

  @override
  List<Object?> get props => [];
}
