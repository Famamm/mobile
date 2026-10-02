import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/admin_profile_entity.dart';
import '../entities/fleet_profile_entity.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, AdminProfileEntity>> getAdminProfile();

  Future<Either<Failure, FleetProfileEntity>> getFleetProfile();

  Future<Either<Failure, void>> selectVehicle(int vehicleId);
}
