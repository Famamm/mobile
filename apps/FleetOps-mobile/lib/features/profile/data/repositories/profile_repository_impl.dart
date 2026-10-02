import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../../domain/entities/admin_profile_entity.dart';
import '../../domain/entities/fleet_profile_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminProfileEntity>> getAdminProfile() async {
    try {
      final model = await remoteDataSource.getAdminProfile();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FleetProfileEntity>> getFleetProfile() async {
    try {
      final model = await remoteDataSource.getFleetProfile();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> selectVehicle(int vehicleId) async {
    try {
      await remoteDataSource.selectVehicle(vehicleId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
