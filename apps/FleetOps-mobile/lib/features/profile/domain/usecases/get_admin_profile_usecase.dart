import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/admin_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetAdminProfileUseCase {
  final ProfileRepository repository;

  GetAdminProfileUseCase(this.repository);

  Future<Either<Failure, AdminProfileEntity>> call() {
    return repository.getAdminProfile();
  }
}
