import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/fleet_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetFleetProfileUseCase {
  final ProfileRepository repository;

  GetFleetProfileUseCase(this.repository);

  Future<Either<Failure, FleetProfileEntity>> call() {
    return repository.getFleetProfile();
  }
}
