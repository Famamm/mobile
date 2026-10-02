import 'package:fleetops_mobile/features/inspection/data/data_sources/inspection_remote_data_source.dart';
import 'package:fleetops_mobile/features/inspection/data/models/inspection_item_model.dart';
import 'package:fleetops_mobile/features/inspection/data/models/inspection_model.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_entity.dart';
import 'package:fleetops_mobile/features/inspection/domain/entities/inspection_item_entity.dart';
import 'package:fleetops_mobile/features/inspection/domain/repositories/inspection_repository.dart';

class InspectionRepositoryImpl implements InspectionRepository {
  final InspectionRemoteDataSource remoteDataSource;

  const InspectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<InspectionItemEntity>> getInspectionItems() async {
    final models = await remoteDataSource.getInspectionItems();
    return models;
  }
  
  @override
  Future<InspectionEntity> getInspectionById(int id) async {
    final response = await remoteDataSource.getInspectionById(id);
    return InspectionModel.fromJson(response);
  }

  @override
  Future<List<InspectionEntity>> getInspectionsByDriver(int driverId) async {
    final response = await remoteDataSource.getInspectionsByDriver(driverId);
    return response.map((item) => InspectionModel.fromJson(item)).toList();
  }

  @override
  Future<List<InspectionEntity>> getInspectionsByVehicle(int vehicleId) async {
    final response = await remoteDataSource.getInspectionsByVehicle(vehicleId);
    return response.map((item) => InspectionModel.fromJson(item)).toList();
  }

  @override
  Future<List<InspectionEntity>> getTodayInspections() async {
    final response = await remoteDataSource.getTodayInspections();
    return response.map((item) => InspectionModel.fromJson(item)).toList();
  }

  @override
  Future<InspectionEntity> updateInspection({
    required int id,
    required int vehicleId,
    required int driverId,
    required DateTime inspectionDate,
    String? status,
    String? notes,
    List<String>? photoPaths,
  }) async {
    final response = await remoteDataSource.updateInspection(
      id: id,
      vehicleId: vehicleId,
      driverId: driverId,
      inspectionDate: inspectionDate,
      status: status,
      notes: notes,
      photoPaths: photoPaths,
    );
    return InspectionModel.fromJson(response);
  }

  @override
  Future<bool> deleteInspection(int id) async {
    return await remoteDataSource.deleteInspection(id);
  }

  @override
  Future<void> submitInspection(
    int vehicleId,
    int driverId,
    List<InspectionItemEntity> items,
  ) async {
    final models = items.map((e) => InspectionItemModel.fromEntity(e)).toList();
    await remoteDataSource.submitInspection(vehicleId, driverId, models);
  }

  @override
  Future<void> updateInspectionItems(
    int id,
    int vehicleId,
    int driverId,
    List<InspectionItemEntity> items,
  ) async {
    final models = items.map((e) => InspectionItemModel.fromEntity(e)).toList();
    await remoteDataSource.updateInspectionItems(
        id, vehicleId, driverId, models);
  }

  @override
  Future<void> updateItemStatus(InspectionItemEntity item) async {}
}
