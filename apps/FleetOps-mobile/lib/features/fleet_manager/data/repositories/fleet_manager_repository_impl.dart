import 'dart:io';

import '../../domain/entities/fleet_manager_entity.dart';
import '../../domain/repositories/fleet_manager_repository.dart';
import '../data_sources/fleet_manager_remote_data_source.dart';

class FleetManagerRepositoryImpl implements FleetManagerRepository {
  final FleetManagerRemoteDataSource remoteDataSource;

  FleetManagerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FleetManagerEntity>> getFleetManagers() =>
      remoteDataSource.getFleetManagers();

  @override
  Future<FleetManagerEntity> getFleetManagerById(int userId) =>
      remoteDataSource.getFleetManagerById(userId);

  @override
  Future<CreateFleetManagerResult> createFleetManager({
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  }) async {
    final res = await remoteDataSource.createFleetManager(
      fullName: fullName,
      address: address,
      phoneNumber: phoneNumber,
      profilePhoto: profilePhoto,
    );
    return CreateFleetManagerResult(
      fleetManager: res.fleetManager,
      generatedPassword: res.generatedPassword,
    );
  }

  @override
  Future<FleetManagerEntity> updateFleetManager({
    required int userId,
    required String fullName,
    required String address,
    required String phoneNumber,
    File? profilePhoto,
  }) => remoteDataSource.updateFleetManager(
    userId: userId,
    fullName: fullName,
    address: address,
    phoneNumber: phoneNumber,
    profilePhoto: profilePhoto,
  );

  @override
  Future<void> deleteFleetManager(int userId) =>
      remoteDataSource.deleteFleetManager(userId);
  
  @override
  Future<Map<String, String>> resetFleetManagerPassword(int userId) {
    return remoteDataSource.resetFleetManagerPassword(userId);
  }
}
