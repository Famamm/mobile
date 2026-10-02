import '../../domain/entities/gps_point.dart';
import '../../domain/repositories/trip_gps_repository.dart';
import '../data_sources/trip_gps_remote_data_source.dart';
import '../models/gps_point_model.dart';

class TripGpsRepositoryImpl implements TripGpsRepository {
  final TripGpsRemoteDataSource remoteDataSource;

  TripGpsRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendGpsPoints({
    required String tripId,
    required List<GpsPoint> points,
  }) async {
    final models = points
        .map((p) => GpsPointModel(
              clientId: p.clientId,
              latitude: p.latitude,
              longitude: p.longitude,
              capturedAt: p.capturedAt,
              accuracyMeters: p.accuracyMeters,
            ))
        .toList();

    await remoteDataSource.sendGpsPoints(tripId: tripId, points: models);
  }
}