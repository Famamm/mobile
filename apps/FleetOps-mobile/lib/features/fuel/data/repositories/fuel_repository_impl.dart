import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import '../../domain/entities/fuel_entity.dart';
import '../../domain/entities/fuel_price_entity.dart';
import '../../domain/repositories/fuel_repository.dart';
import '../datasources/fuel_remote_data_source.dart';

class FuelRepositoryImpl implements FuelRepository {
  final FuelRemoteDataSource remoteDataSource;

  FuelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FuelEntity>> createFuel({
    required int vehicleId,
    required int organizationId,
    required String fuelType,
    required double jmlLiter,
    required int odometerIsi,
    String catatan = '',
    File? fuelPhoto,
  }) async {
    try {
      final result = await remoteDataSource.createFuel(
        vehicleId: vehicleId,
        organizationId: organizationId,
        fuelType: fuelType,
        jmlLiter: jmlLiter,
        odometerIsi: odometerIsi,
        catatan: catatan,
        fuelPhoto: fuelPhoto,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Gagal menambah pencatatan BBM: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FuelPriceEntity>>> getFuelPrices() async {
    try {
      final result = await remoteDataSource.getFuelPrices();
      return Right(result
          .map((m) => FuelPriceEntity(
                id: m.id,
                fuelType: m.fuelType,
                pricePerLiter: m.pricePerLiter,
              ))
          .toList());
    } catch (e) {
      return Left(ServerFailure(
          message: 'Gagal mengambil daftar BBM: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FuelEntity>>> getAllFuels() async {
    try {
      final result = await remoteDataSource.getAllFuels();
      return Right(result);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Gagal mengambil data BBM: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FuelEntity>> getFuelById(String id) async {
    try {
      final result = await remoteDataSource.getFuelById(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Gagal mengambil detail BBM: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FuelEntity>>> getFuelsByVehicleId(
      String vehicleId) async {
    try {
      final result = await remoteDataSource.getFuelsByVehicleId(vehicleId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Gagal mengambil data BBM kendaraan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FuelEntity>> updateFuel(
      String id, FuelEntity fuel) async {
    try {
      throw UnimplementedError();
    } catch (e) {
      return Left(ServerFailure(
          message: 'Gagal mengupdate pencatatan BBM: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFuel(String id) async {
    try {
      await remoteDataSource.deleteFuel(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Gagal menghapus pencatatan BBM: ${e.toString()}'));
    }
  }
}
