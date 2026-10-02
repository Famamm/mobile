import 'dart:io';

import 'package:core/core.dart';

import '../models/fuel_model.dart';
import '../models/fuel_price_model.dart';

abstract class FuelRemoteDataSource {
  Future<FuelModel> createFuel({
    required int vehicleId,
    required int organizationId,
    required String fuelType,
    required double jmlLiter,
    required int odometerIsi,
    String catatan,
    File? fuelPhoto,
  });

  Future<List<FuelPriceModel>> getFuelPrices();

  Future<List<FuelModel>> getAllFuels();
  Future<FuelModel> getFuelById(String id);
  Future<List<FuelModel>> getFuelsByVehicleId(String vehicleId);
  Future<FuelModel> updateFuel(String id, FuelModel fuelModel);
  Future<void> deleteFuel(String id);
}

class FuelRemoteDataSourceImpl implements FuelRemoteDataSource {
  final HttpService httpService;

  FuelRemoteDataSourceImpl({required this.httpService});

  @override
  Future<FuelModel> createFuel({
    required int vehicleId,
    required int organizationId,
    required String fuelType,
    required double jmlLiter,
    required int odometerIsi,
    String catatan = '',
    File? fuelPhoto,
  }) async {
    final fields = {
      'VehicleId': vehicleId.toString(),
      'OrganizationId': organizationId.toString(),
      'FuelType': fuelType,
      'JmlLiter': jmlLiter.toString(),
      'OdometerIsi': odometerIsi.toString(),
      'Catatan': catatan,
    };

    final response = await httpService.postForm(
      ApiConfig.driverCreateFuelEndpoint,
      fields,
      file: fuelPhoto,
      fileFieldName: fuelPhoto != null ? 'FuelPhoto' : null,
    );

    return FuelModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<FuelPriceModel>> getFuelPrices() async {
    final response = await httpService.get(ApiConfig.driverGetFuelPricesEndpoint);
    final list = response as List<dynamic>;
    return list
        .map((e) => FuelPriceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FuelModel>> getAllFuels() async {
    throw UnimplementedError();
  }

  @override
  Future<FuelModel> getFuelById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<FuelModel>> getFuelsByVehicleId(String vehicleId) async {
    throw UnimplementedError();
  }

  @override
  Future<FuelModel> updateFuel(String id, FuelModel fuelModel) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFuel(String id) async {
    throw UnimplementedError();
  }
}
