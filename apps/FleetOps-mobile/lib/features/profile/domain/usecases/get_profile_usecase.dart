import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call() {
    return repository.getProfile();
  }
}
