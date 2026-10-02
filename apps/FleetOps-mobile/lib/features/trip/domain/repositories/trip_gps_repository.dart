import '../entities/gps_point.dart';

abstract class TripGpsRepository {
  Future<void> sendGpsPoints({
    required String tripId,
    required List<GpsPoint> points,
  });
}