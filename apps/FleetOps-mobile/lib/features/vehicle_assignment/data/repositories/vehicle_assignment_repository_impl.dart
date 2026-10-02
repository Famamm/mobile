import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

import '../data_sources/vehicle_assignment_remote_data_source.dart';
import '../../domain/entities/vehicle_assignment_entity.dart';
import '../../domain/repositories/vehicle_assignment_repository.dart';
import '../models/vehicle_assignment_model.dart';

class VehicleAssignmentRepositoryImpl implements VehicleAssignmentRepository {
  final VehicleAssignmentRemoteDataSource remoteDataSource;

  VehicleAssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<VehicleAssignmentEntity> getVehicleAssignment() async {
    final vehicles = await remoteDataSource.getVehicles();
    final drivers = await remoteDataSource.getAvailableDrivers();

    return VehicleAssignmentModel.fromPayload(
      vehicles: vehicles,
      drivers: drivers,
    );
  }

  @override
  Future<Driver?> getCurrentDriver(int vehicleId) {
    return remoteDataSource.getCurrentDriver(vehicleId);
  }

  @override
  Future<List<Driver>> getAvailableDrivers() {
    return remoteDataSource.getAvailableDrivers();
  }

  @override
  Future<void> assignDriver({
    required int vehicleId,
    required int driverId,
  }) async {
    await remoteDataSource.assignDriver(
      vehicleId: vehicleId,
      driverId: driverId,
    );
  }

  @override
  Future<void> unassignDriver(int vehicleId) {
    return remoteDataSource.unassignDriver(vehicleId);
  }
}
