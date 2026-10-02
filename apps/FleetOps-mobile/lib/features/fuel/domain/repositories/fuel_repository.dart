import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../entities/fuel_entity.dart';
import '../entities/fuel_price_entity.dart';

abstract class FuelRepository {
  Future<Either<Failure, FuelEntity>> createFuel({
    required int vehicleId,
    required int organizationId,
    required String fuelType,
    required double jmlLiter,
    required int odometerIsi,
    String catatan,
    File? fuelPhoto,
  });

  Future<Either<Failure, List<FuelPriceEntity>>> getFuelPrices();

  Future<Either<Failure, List<FuelEntity>>> getAllFuels();
  Future<Either<Failure, FuelEntity>> getFuelById(String id);
  Future<Either<Failure, List<FuelEntity>>> getFuelsByVehicleId(
      String vehicleId);
  Future<Either<Failure, FuelEntity>> updateFuel(String id, FuelEntity fuel);
  Future<Either<Failure, void>> deleteFuel(String id);
}
