import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/gps_point.dart';
import '../../domain/repositories/trip_gps_repository.dart';

class GpsTrackingService {
  final TripGpsRepository repository;
  final String tripId;

  /// Kirim kalau buffer sudah mencapai jumlah ini
  static const int _batchSize = 5;

  /// Kirim paksa kalau sudah lewat durasi ini (walau buffer belum penuh)
  static const Duration _flushInterval = Duration(seconds: 30);

  final List<GpsPoint> _buffer = [];
  StreamSubscription<Position>? _positionSub;
  Timer? _flushTimer;
  bool _isSending = false;
  bool _isStopped = false;
  final _uuid = const Uuid();
  final List<GpsPoint> _trackedPoints = [];
  final ValueNotifier<List<GpsPoint>> trackedPoints =
      ValueNotifier<List<GpsPoint>>([]);

  GpsTrackingService({required this.repository, required this.tripId});

  void start() {
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // minimal 10 meter baru dianggap titik baru
      ),
    ).listen(_onPosition, onError: (e) => print('[GPS] stream error: $e'));

    _flushTimer = Timer.periodic(_flushInterval, (_) => _flush());
  }

  void _onPosition(Position position) {
    if (_isStopped) return;

    final point = GpsPoint(
      clientId: _uuid.v4(),
      latitude: position.latitude,
      longitude: position.longitude,
      capturedAt: DateTime.now().toUtc(),
      accuracyMeters: position.accuracy,
    );

    _buffer.add(point);
    _trackedPoints.add(point);
    trackedPoints.value = List.unmodifiable(_trackedPoints);

    if (_buffer.length >= _batchSize) {
      _flush();
    }
  }

  Future<void> _flush() async {
    if (_isSending || _buffer.isEmpty) return;

    _isSending = true;
    final pointsToSend = List<GpsPoint>.from(_buffer);
    _buffer.clear();

    try {
      await repository.sendGpsPoints(tripId: tripId, points: pointsToSend);
      print('[GPS] Sent ${pointsToSend.length} points');
    } catch (e) {
      // Gagal → kembalikan ke buffer untuk dicoba lagi
      _buffer.insertAll(0, pointsToSend);
      print('[GPS] Failed to send, requeued ${pointsToSend.length} points: $e');
    } finally {
      _isSending = false;
    }
  }

  Future<void> stop() async {
    _isStopped = true;
    _flushTimer?.cancel();
    await _positionSub?.cancel();
    await _flush();
  }

  void dispose() {
    trackedPoints.dispose();
  }
}
