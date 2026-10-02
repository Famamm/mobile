class GpsPoint {
  final String clientId;
  final double latitude;
  final double longitude;
  final DateTime capturedAt;
  final double accuracyMeters;

  const GpsPoint({
    required this.clientId,
    required this.latitude,
    required this.longitude,
    required this.capturedAt,
    required this.accuracyMeters,
  });

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'latitude': latitude,
        'longitude': longitude,
        'capturedAt': capturedAt.toUtc().toIso8601String(),
        'accuracyMeters': accuracyMeters,
      };
}