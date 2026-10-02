import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../repositories/fuel_repository.dart';

class DeleteFuelUsecase {
  final FuelRepository repository;

  DeleteFuelUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteFuel(id);
  }
}
