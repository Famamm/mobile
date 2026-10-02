import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_entity.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';

abstract class InspectionRepository {
  /// Get semua inspection items
  Future<List<InspectionItemEntity>> getInspectionItems();

  /// Get inspection by ID
  Future<InspectionEntity> getInspectionById(int id);

  /// Get inspections by driver ID
  Future<List<InspectionEntity>> getInspectionsByDriver(int driverId);

  /// Get inspections by vehicle ID
  Future<List<InspectionEntity>> getInspectionsByVehicle(int vehicleId);

  /// Get today's inspections
  Future<List<InspectionEntity>> getTodayInspections();

  /// Update inspection
  Future<InspectionEntity> updateInspection({
    required int id,
    required int vehicleId,
    required int driverId,
    required DateTime inspectionDate,
    String? status,
    String? notes,
    List<String>? photoPaths,
  });

  /// Delete inspection
  Future<bool> deleteInspection(int id);

  /// Submit inspection
  Future<void> submitInspection(
    int vehicleId,
    int driverId,
    List<InspectionItemEntity> items,
  );

  /// Update inspection
  Future<void> updateInspectionItems(
    int id,
    int vehicleId,
    int driverId,
    List<InspectionItemEntity> items,
  );

  /// Update item status
  Future<void> updateItemStatus(InspectionItemEntity item);
}
