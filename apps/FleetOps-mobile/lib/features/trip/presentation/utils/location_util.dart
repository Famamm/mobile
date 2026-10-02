import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:core/core.dart';

class LocationUtil {
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          SnackBarUtil.showError(context, 'Izin lokasi ditolak');
        }
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      if (context.mounted) {
        SnackBarUtil.showError(context, 'Gagal mendapatkan lokasi');
      }
      return null;
    }
  }

  static Future<String> getLocationName(
    double latitude,
    double longitude,
    BuildContext context,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(const Duration(seconds: 5), onTimeout: () => []);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
      }
      return '';
    } catch (e) {
      if (context.mounted) {
        SnackBarUtil.showError(context, 'Gagal mendapatkan nama lokasi');
      }
      return '';
    }
  }
}
