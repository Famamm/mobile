import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../repositories/profile_repository.dart';

class SelectVehicleUseCase {
  final ProfileRepository repository;

  SelectVehicleUseCase(this.repository);

  Future<Either<Failure, void>> call(int vehicleId) =>
      repository.selectVehicle(vehicleId);
}
