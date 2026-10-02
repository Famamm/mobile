import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/fuel_entity.dart';
import '../repositories/fuel_repository.dart';

class CreateFuelUsecase {
  final FuelRepository repository;

  CreateFuelUsecase(this.repository);

  Future<Either<Failure, FuelEntity>> call({
    required int vehicleId,
    required int organizationId,
    required String fuelType,
    required double jmlLiter,
    required int odometerIsi,
    String catatan = '',
    File? fuelPhoto,
  }) {
    return repository.createFuel(
      vehicleId: vehicleId,
      organizationId: organizationId,
      fuelType: fuelType,
      jmlLiter: jmlLiter,
      odometerIsi: odometerIsi,
      catatan: catatan,
      fuelPhoto: fuelPhoto,
    );
  }
}
