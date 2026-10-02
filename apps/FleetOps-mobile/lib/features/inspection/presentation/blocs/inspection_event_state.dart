import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_entity.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';

// ============ BLoC Events ============
abstract class InspectionEvent {}

class GetInspectionItemsEvent extends InspectionEvent {}

class GetInspectionByIdEvent extends InspectionEvent {
  final int id;
  GetInspectionByIdEvent({required this.id});
}

class GetInspectionsByDriverEvent extends InspectionEvent {
  final int driverId;
  GetInspectionsByDriverEvent({required this.driverId});
}

class GetInspectionsByVehicleEvent extends InspectionEvent {
  final int vehicleId;
  GetInspectionsByVehicleEvent({required this.vehicleId});
}

class GetTodayInspectionsEvent extends InspectionEvent {}

class CreateInspectionEvent extends InspectionEvent {
  final int vehicleId;
  final int driverId;
  final DateTime inspectionDate;
  final String? status;
  final String? notes;
  final List<String>? photoPaths;

  CreateInspectionEvent({
    required this.vehicleId,
    required this.driverId,
    required this.inspectionDate,
    this.status,
    this.notes,
    this.photoPaths,
  });
}

class UpdateInspectionEvent extends InspectionEvent {
  final int id;
  final int vehicleId;
  final int driverId;
  final DateTime inspectionDate;
  final String? status;
  final String? notes;
  final List<String>? photoPaths;

  UpdateInspectionEvent({
    required this.id,
    required this.vehicleId,
    required this.driverId,
    required this.inspectionDate,
    this.status,
    this.notes,
    this.photoPaths,
  });
}

class DeleteInspectionEvent extends InspectionEvent {
  final int id;
  DeleteInspectionEvent({required this.id});
}

class SubmitInspectionEvent extends InspectionEvent {
  final int vehicleId;
  final List<InspectionItemEntity> items;

  SubmitInspectionEvent({required this.vehicleId, required this.items});
}

// ============ BLoC States ============
abstract class InspectionState {}

class InspectionInitial extends InspectionState {}

class InspectionLoading extends InspectionState {}

class InspectionItemsLoaded extends InspectionState {
  final List<InspectionItemEntity> items;
  InspectionItemsLoaded({required this.items});
}

class InspectionLoaded extends InspectionState {
  final InspectionEntity inspection;
  InspectionLoaded({required this.inspection});
}

class InspectionsLoaded extends InspectionState {
  final List<InspectionEntity> inspections;
  InspectionsLoaded({required this.inspections});
}

class InspectionCreated extends InspectionState {
  final InspectionEntity inspection;
  InspectionCreated({required this.inspection});
}

class InspectionUpdated extends InspectionState {
  final InspectionEntity inspection;
  InspectionUpdated({required this.inspection});
}

class InspectionDeleted extends InspectionState {}

class InspectionSubmitted extends InspectionState {}

class InspectionError extends InspectionState {
  final String message;
  InspectionError({required this.message});
}
