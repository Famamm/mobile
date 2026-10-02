import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/fuel_price_entity.dart';
import '../repositories/fuel_repository.dart';

class GetFuelPricesUsecase {
  final FuelRepository repository;

  GetFuelPricesUsecase(this.repository);

  Future<Either<Failure, List<FuelPriceEntity>>> call() {
    return repository.getFuelPrices();
  }
}
