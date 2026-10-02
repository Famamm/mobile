import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/fuel_entity.dart';
import '../repositories/fuel_repository.dart';

class GetFuelsByVehicleUsecase {
  final FuelRepository repository;

  GetFuelsByVehicleUsecase(this.repository);

  Future<Either<Failure, List<FuelEntity>>> call(String vehicleId) {
    return repository.getFuelsByVehicleId(vehicleId);
  }
}
