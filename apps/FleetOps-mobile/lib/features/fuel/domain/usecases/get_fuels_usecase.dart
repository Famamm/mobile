import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/fuel_entity.dart';
import '../repositories/fuel_repository.dart';

class GetFuelsUsecase {
  final FuelRepository repository;

  GetFuelsUsecase(this.repository);

  Future<Either<Failure, List<FuelEntity>>> call() {
    return repository.getAllFuels();
  }
}
