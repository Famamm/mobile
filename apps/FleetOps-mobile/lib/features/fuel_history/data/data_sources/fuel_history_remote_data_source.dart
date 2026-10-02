import 'package:core/core.dart';

import '../models/fuel_history_model.dart';

abstract class FuelHistoryRemoteDataSource {
  Future<List<FuelHistoryModel>> getFuelHistories({String? searchQuery});
  Future<FuelHistoryModel> getFuelDetail(String fuelId);
}

class FuelHistoryRemoteDataSourceImpl implements FuelHistoryRemoteDataSource {
  final HttpService httpService;

  FuelHistoryRemoteDataSourceImpl({required this.httpService});

  @override
  Future<List<FuelHistoryModel>> getFuelHistories({String? searchQuery}) async {
    final response = await httpService.get(ApiConfig.driverGetFuelHistoryEndpoint);

    List<dynamic> rawList;
    if (response is Map && response['data'] != null) {
      rawList = response['data'] as List<dynamic>;
    } else if (response is List) {
      rawList = response;
    } else {
      rawList = [];
    }

    var results = rawList
        .map((e) => FuelHistoryModel.fromListJson(e as Map<String, dynamic>))
        .toList();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      results = results.where((e) {
        final tanggal =
            '${e.date.day.toString().padLeft(2, '0')}-${e.date.month.toString().padLeft(2, '0')}-${e.date.year}';
        return e.vehicleName.toLowerCase().contains(q) ||
            e.plateNumber.toLowerCase().contains(q) ||
            e.fuelType.toLowerCase().contains(q) ||
            tanggal.contains(q);
      }).toList();
    }

    return results;
  }

  @override
  Future<FuelHistoryModel> getFuelDetail(String fuelId) async {
    final response = await httpService.get(
      ApiConfig.driverGetFuelByIdEndpoint.replaceFirst(
        '{fuelId}',
        fuelId,
      ),
    );

    Map<String, dynamic> json;
    if (response is Map && response['data'] != null) {
      final data = response['data'];
      if (data is List && data.isNotEmpty) {
        json = data.first as Map<String, dynamic>;
      } else if (data is Map) {
        json = data as Map<String, dynamic>;
      } else {
        throw Exception('Data detail BBM tidak ditemukan');
      }
    } else if (response is Map) {
      json = response as Map<String, dynamic>;
    } else {
      throw Exception('Response tidak valid');
    }

    return FuelHistoryModel.fromDetailJson(json);
  }
}
