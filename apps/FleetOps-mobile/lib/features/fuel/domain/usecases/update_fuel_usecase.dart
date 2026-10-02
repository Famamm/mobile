import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/fuel_entity.dart';
import '../repositories/fuel_repository.dart';

class UpdateFuelUsecase {
  final FuelRepository repository;

  UpdateFuelUsecase(this.repository);

  Future<Either<Failure, FuelEntity>> call(String id, FuelEntity fuel) {
    return repository.updateFuel(id, fuel);
  }
}
