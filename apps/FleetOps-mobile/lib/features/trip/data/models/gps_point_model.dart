import '../../domain/entities/gps_point.dart';

class GpsPointModel extends GpsPoint {
  const GpsPointModel({
    required super.clientId,
    required super.latitude,
    required super.longitude,
    required super.capturedAt,
    required super.accuracyMeters,
  });
}