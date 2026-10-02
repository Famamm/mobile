import 'package:core/core.dart';

import '../models/statistic_model.dart';

abstract class StatisticRemoteDataSource {
  Future<StatisticModel> getStatistic({required int month, required int year});
}

class StatisticRemoteDataSourceImpl implements StatisticRemoteDataSource {
  final HttpService httpService;

  StatisticRemoteDataSourceImpl({required this.httpService});

  @override
  Future<StatisticModel> getStatistic({
    required int month,
    required int year,
  }) async {
    final response = await httpService.get(
      '${ApiConfig.fleetGetStatisticsEndpoint}?bulan=$month&tahun=$year',
    );

    if (response is! Map<String, dynamic>) {
      throw const FormatException('Format response statistik tidak valid');
    }

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Data statistik tidak tersedia');
    }

    return StatisticModel.fromJson(data);
  }
}
