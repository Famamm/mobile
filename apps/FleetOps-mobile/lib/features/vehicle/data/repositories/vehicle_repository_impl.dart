import 'package:fleetops_mobile/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/entities/vehicle.dart';
import '../models/vehicle_image_upload_dto.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Vehicle> addVehicle(VehicleImageUploadDTO dto) async {
    final model = await remoteDataSource.addVehicle(dto);
    return model.toEntity();
  }

  @override
  Future<List<Vehicle>> getVehiclesByDriver(int driverId) async {
    final models = await remoteDataSource.getVehiclesByDriver(driverId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Vehicle>> getVehiclesByOrganization(int organizationId) async {
    try {
      final models = await remoteDataSource.getVehiclesByOrganization(
        organizationId,
      );
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get vehicles by organization: $e');
    }
  }

  @override
  Future<Vehicle> getVehicleById(int vehicleId) async {
    final model = await remoteDataSource.getVehicleById(vehicleId);
    return model.toEntity();
  }

  @override
  Future<Vehicle> updateVehicle(
    int vehicleId,
    VehicleImageUploadDTO dto,
  ) async {
    final model = await remoteDataSource.updateVehicle(vehicleId, dto);
    return model.toEntity();
  }

  @override
  Future<void> deleteVehicle(int vehicleId) async {
    await remoteDataSource.deleteVehicle(vehicleId);
  }
}
