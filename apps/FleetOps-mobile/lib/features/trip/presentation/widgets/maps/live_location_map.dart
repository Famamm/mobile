import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entities/gps_point.dart';


class TripLiveMap extends StatefulWidget {
  final Position? currentLocation;
  final String startLocation;
  final double? startLat;
  final double? startLng;

  /// Stream titik yang sudah dilalui (dari GpsTrackingService)
  final ValueNotifier<List<GpsPoint>>? trackedPoints;

  /// Auto-follow kamera ke posisi terkini
  final bool autoFollow;

  const TripLiveMap({
    super.key,
    this.currentLocation,
    required this.startLocation,
    this.startLat,
    this.startLng,
    this.trackedPoints,
    this.autoFollow = true,
  });

  @override
  State<TripLiveMap> createState() => _TripLiveMapState();
}

class _TripLiveMapState extends State<TripLiveMap> {
  final MapController _mapController = MapController();

  static const _fallbackCenter = LatLng(-6.2088, 106.8456); // Jakarta

  List<GpsPoint> _tracked = [];
  bool _userInteracted = false; // kalau user geser peta, stop auto-follow

  @override
  void initState() {
    super.initState();
    widget.trackedPoints?.addListener(_onTrackedChanged);
    _onTrackedChanged();
  }

  @override
  void dispose() {
    widget.trackedPoints?.removeListener(_onTrackedChanged);
    super.dispose();
  }

  void _onTrackedChanged() {
    final points = widget.trackedPoints?.value ?? const [];
    if (points.length == _tracked.length) return;

    _tracked = points;

    if (mounted) setState(() {});

    // Auto-follow kamera ke titik terakhir
    if (widget.autoFollow && !_userInteracted && _tracked.isNotEmpty) {
      final last = _tracked.last;
      _mapController.move(LatLng(last.latitude, last.longitude), 16);
    }
  }

  // ─── Titik tengah peta ───────────────────────────────────────
  LatLng get _currentLatLng {
    if (_tracked.isNotEmpty) {
      final last = _tracked.last;
      return LatLng(last.latitude, last.longitude);
    }
    if (widget.currentLocation != null) {
      return LatLng(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
      );
    }
    if (widget.startLat != null && widget.startLng != null) {
      return LatLng(widget.startLat!, widget.startLng!);
    }
    return _fallbackCenter;
  }

  void _centerToCurrent() {
    _userInteracted = false;
    _mapController.move(_currentLatLng, 16);
  }

  /// Fit kamera ke seluruh jalur
  void _fitAll() {
    if (_tracked.length < 2) return;
    final lats = _tracked.map((p) => p.latitude);
    final lngs = _tracked.map((p) => p.longitude);
    final bounds = LatLngBounds(
      LatLng(lats.reduce((a, b) => a < b ? a : b),
          lngs.reduce((a, b) => a < b ? a : b)),
      LatLng(lats.reduce((a, b) => a > b ? a : b),
          lngs.reduce((a, b) => a > b ? a : b)),
    );
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
    );
    _userInteracted = true;
  }

  // ─── Markers ─────────────────────────────────────────────────
  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Marker start (kalau ada koordinat start)
    if (widget.startLat != null && widget.startLng != null) {
      markers.add(
        Marker(
          point: LatLng(widget.startLat!, widget.startLng!),
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_on,
            color: Colors.green,
            size: 40,
          ),
        ),
      );
    }

    // Marker posisi terkini — ambil dari trackedPoints kalau ada
    LatLng? current;
    if (_tracked.isNotEmpty) {
      final last = _tracked.last;
      current = LatLng(last.latitude, last.longitude);
    } else if (widget.currentLocation != null) {
      current = LatLng(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
      );
    }

    if (current != null) {
      markers.add(
        Marker(
          point: current,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: 32,
          ),
        ),
      );
    }

    return markers;
  }

  // ─── Polylines ───────────────────────────────────────────────
  List<Polyline> _buildPolylines() {
    // Prioritas: jalur tracked (banyak titik)
    if (_tracked.length >= 2) {
      return [
        Polyline(
          points: _tracked
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList(),
          color: AppColors.primary,
          strokeWidth: 4,
        ),
      ];
    }

    // Fallback: garis lurus dari start ke current
    if (widget.currentLocation != null &&
        widget.startLat != null &&
        widget.startLng != null) {
      return [
        Polyline(
          points: [
            LatLng(widget.startLat!, widget.startLng!),
            LatLng(
              widget.currentLocation!.latitude,
              widget.currentLocation!.longitude,
            ),
          ],
          color: Colors.blue,
          strokeWidth: 4,
        ),
      ];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLatLng,
                initialZoom: 15,
                minZoom: 3,
                maxZoom: 18,
                onMapEvent: (event) {
                  // Kalau user geser/zoom manual, matikan auto-follow
                  if (event is MapEventMoveStart) {
                    _userInteracted = true;
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.yourapp',
                ),
                if (_buildPolylines().isNotEmpty)
                  PolylineLayer(polylines: _buildPolylines()),
                MarkerLayer(markers: _buildMarkers()),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),

            // Tombol fit all (kalau jalur > 2 titik)
            if (_tracked.length >= 2)
              Positioned(
                bottom: 8,
                right: 56,
                child: FloatingActionButton.small(
                  heroTag: 'trip_map_fit',
                  backgroundColor: Colors.white,
                  onPressed: _fitAll,
                  child: const Icon(Icons.fit_screen, color: Colors.blue),
                ),
              ),

            // Tombol ke lokasi saat ini
            Positioned(
              bottom: 8,
              right: 8,
              child: FloatingActionButton.small(
                heroTag: 'trip_map_center',
                backgroundColor: Colors.white,
                onPressed: _centerToCurrent,
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}