import 'package:core/core.dart';

import '../models/gps_point_model.dart';

abstract class TripGpsRemoteDataSource {
  Future<void> sendGpsPoints({
    required String tripId,
    required List<GpsPointModel> points,
  });
}

class TripGpsRemoteDataSourceImpl implements TripGpsRemoteDataSource {
  final HttpService httpService;

  TripGpsRemoteDataSourceImpl(this.httpService);

  @override
  Future<void> sendGpsPoints({
    required String tripId,
    required List<GpsPointModel> points,
  }) async {
    final endpoint = 'api/drivers/trips/$tripId/gps';
    print('[GPS][DS] POST $endpoint dengan ${points.length} titik');

    await httpService.post(endpoint, {
      'points': points.map((p) => p.toJson()).toList(),
    });
  }
}
