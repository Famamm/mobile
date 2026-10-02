import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:core/core.dart';

import '../../../../injection_container.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
import '../blocs/end_trip_bloc.dart';
import '../blocs/end_trip_event.dart';

class EndTripSubmissionData {
  final GlobalKey<FormState> formKey;
  final String titikAkhir;
  final File selectedPhoto;
  final Duration duration;
  final int odometerAwal;
  final String tripId;
  final String startLocation;
  final int Function() getOdometerAkhir;
  final String Function() getNote;
  final double Function(int) getKecepatanRataRata;

  EndTripSubmissionData({
    required this.formKey,
    required this.titikAkhir,
    required this.selectedPhoto,
    required this.duration,
    required this.odometerAwal,
    required this.tripId,
    required this.startLocation,
    required this.getOdometerAkhir,
    required this.getNote,
    required this.getKecepatanRataRata,
  });
}

class TripEndSubmissionService {
  String? validateSubmission({
    required GlobalKey<FormState> formKey,
    required File? selectedPhoto,
    required int odometerAkhir,
    required int odometerAwal,
  }) {
    if (!formKey.currentState!.validate()) {
      return 'Pastikan semua field terisi dengan benar';
    }

    if (selectedPhoto == null) {
      return 'Dokumentasi foto wajib diunggah';
    }

    if (odometerAkhir < odometerAwal) {
      return 'Odometer akhir tidak boleh kurang dari odometer awal';
    }

    return null;
  }

  // Get driver ID dengan fallback
  int _getDriverId(BuildContext context) {
    final tokenService = sl<TokenService>();
    return tokenService.getDriverId() ??
        ((context.read<AuthBloc>().state is AuthSuccess)
            ? (context.read<AuthBloc>().state as AuthSuccess).driverId ?? 1
            : 1);
  }

  // Submit end trip
  Future<void> submitEndTrip({
    required BuildContext context,
    required EndTripSubmissionData data,
    required Position? currentLocation,
    required Function(String) onError,
  }) async {
    // Validasi
    final validationError = validateSubmission(
      formKey: data.formKey,
      selectedPhoto: data.selectedPhoto,
      odometerAkhir: data.getOdometerAkhir(),
      odometerAwal: data.odometerAwal,
    );

    if (validationError != null) {
      onError(validationError);
      return;
    }

    // Get data yang diperlukan
    final tokenService = sl<TokenService>();
    final driverId = _getDriverId(context);
    final vehicleId = tokenService.getActiveVehicleId();

    if (vehicleId == null) {
      onError('Kendaraan tidak ditemukan. Pilih kendaraan di Profile.');
      return;
    }

    // Buat event dan add ke bloc
    final odometerAkhir = data.getOdometerAkhir();
    final kecepatanRataRata = data.getKecepatanRataRata(odometerAkhir);

    context.read<EndTripBloc>().add(
          EndTripSubmitted(
            tripId: int.tryParse(data.tripId) ?? 0,
            driverId: driverId,
            vehicleId: vehicleId,
            startLocation: data.startLocation,
            endLocation: data.titikAkhir,
            dokumentasiFoto: data.selectedPhoto,
            odometerAkhir: odometerAkhir,
            odometerAwal: data.odometerAwal,
            durasiPerjalanan: data.duration,
            kecepatanRataRata: kecepatanRataRata,
            note: data.getNote(),
            kordAkhirLatitude: currentLocation?.latitude,
            kordAkhirLongitude: currentLocation?.longitude,
          ),
        );
  }
}
