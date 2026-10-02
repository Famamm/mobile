import 'package:fleetops_mobile/features/inspection/data/models/inspection_item_model.dart';

abstract class InspectionRemoteDataSource {
  /// Get semua inspection items
  Future<List<InspectionItemModel>> getInspectionItems();

  /// Get inspection by ID
  Future<Map<String, dynamic>> getInspectionById(int id);

  /// Get inspections by driver ID
  Future<List<Map<String, dynamic>>> getInspectionsByDriver(int driverId);

  /// Get inspections by vehicle ID
  Future<List<Map<String, dynamic>>> getInspectionsByVehicle(int vehicleId);

  /// Get today's inspections
  Future<List<Map<String, dynamic>>> getTodayInspections();

  /// Update inspection
  Future<Map<String, dynamic>> updateInspection({
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
      int vehicleId, int driverId, List<InspectionItemModel> items);

  /// Update inspection by id (PUT /inspections/update/{id})
  Future<void> updateInspectionItems(
      int id, int vehicleId, int driverId, List<InspectionItemModel> items);
}
