import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../../injection_container.dart';

import '../../pages/trip_active_page.dart';
import '../../utils/location_util.dart';
import '../components/dialog_no_inspection.dart';
import '../components/dialog_no_vehicle.dart';
import '../../blocs/start_trip_bloc.dart';
import '../../blocs/start_trip_event.dart';
import '../../blocs/start_trip_state.dart';

class StartTripForm extends StatefulWidget {
  const StartTripForm({super.key});

  @override
  State<StartTripForm> createState() => _StartTripFormState();
}

class _StartTripFormState extends State<StartTripForm> {
  final formKey = GlobalKey<FormState>();
  final titikAwalController = TextEditingController();
  final odometerAwalController = TextEditingController();

  Position? _currentLocation;
  bool _isGettingLocation = false;
  int? get _driverId => sl<TokenService>().getDriverId();
  int? get _vehicleId => sl<TokenService>().getActiveVehicleId();
  int get _minOdometer => sl<TokenService>().getActiveVehicleOdometer();

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      final position = await LocationUtil.getCurrentLocation(context);
      if (position != null && mounted) {
        setState(() => _currentLocation = position);
        final locationName = await LocationUtil.getLocationName(
          position.latitude,
          position.longitude,
          context,
        );
        if (mounted && locationName.isNotEmpty) {
          titikAwalController.text = locationName;
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  String? _validateEmpty(String? value) =>
      value?.isEmpty ?? true ? 'Wajib diisi' : null;

  String? _validateNumber(String? value) {
    if (value?.isEmpty ?? true) return 'Odometer awal wajib diisi';
    try {
      final v = int.parse(value!.trim());
      if (v < _minOdometer)
        return 'Odometer awal tidak boleh kurang dari $_minOdometer km';
      return null;
    } on FormatException {
      return 'Odometer awal harus berupa angka';
    }
  }

  @override
  void dispose() {
    titikAwalController.dispose();
    odometerAwalController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final vehicleId = _vehicleId;
    final driverId = _driverId;

    // Validasi vehicle
    if (vehicleId == null) {
      showDialog(context: context, builder: (ctx) => DialogNoVehicle());
      return;
    }

    // Validasi driver
    if (driverId == null) {
      SnackBarUtil.showError(
        context,
        'Session tidak valid. Silakan login kembali.',
      );
      return;
    }

    if (!formKey.currentState!.validate()) {
      SnackBarUtil.showError(
        context,
        'Pastikan semua field terisi dengan benar',
      );
      return;
    }

    // Ambil referensi bloc SEBELUM await
    final startTripBloc = context.read<StartTripBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(color: AppColors.primary),
                Gap(16.0),
                Text('Memulai perjalanan...'),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    Navigator.pop(context);

    try {
      if (_currentLocation == null) {
        SnackBarUtil.showError(context, 'Gagal mendapatkan lokasi. Coba lagi.');
        return;
      }
      final odometerAwal = int.parse(odometerAwalController.text.trim());

      // Pakai referensi bloc yang sudah diambil sebelum await
      startTripBloc.add(
        StartTripSubmitted(
          driverId: driverId,
          vehicleId: vehicleId,
          titikAwal: titikAwalController.text,
          titikAkhir: '',
          odometerAwal: odometerAwal,
          kordAwalLatitude: _currentLocation?.latitude,
          kordAwalLongitude: _currentLocation?.longitude,
        ),
      );
    } on FormatException {
      SnackBarUtil.showError(
        context,
        'Odometer awal harus berupa angka yang valid',
      );
    } catch (e) {
      SnackBarUtil.showError(context, 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocListener<StartTripBloc, StartTripState>(
        listener: (context, state) async {
          if (state is StartTripSuccess) {
            final odometerAwal = int.parse(odometerAwalController.text.trim());
            final startLocation = titikAwalController.text.trim();
            titikAwalController.clear();
            odometerAwalController.clear();
            await Navigator.pushNamed(
              context,
              TripActivePage.routeName,
              arguments: {
                'startLocation': startLocation,
                'odometerAwal': odometerAwal,
                'tripId': state.tripId,
              },
            );
            // Setelah kembali dari trip, setState agar getter _minOdometer dibaca ulang
            if (context.mounted) setState(() {});
          } else if (state is StartTripError) {
            final isInspectionError = state.message.toLowerCase().contains(
                  'inspection',
                );
            if (isInspectionError) {
              showDialog(
                context: context,
                builder: (ctx) => DialogNoInspection(parentContext: context),
              );
            } else {
              SnackBarUtil.showError(context, state.message);
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input Data Keberangkatan',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16.0),
            // Input Titik Awal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleLabel('Titik Awal', required: true),
                CustomTextField(
                  borderRadius: 8,
                  controller: titikAwalController,
                  hintText: 'Tempat, Kota, Provinsi',
                  validator: _validateEmpty,
                ),
                const Gap(8.0),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                        AppColors.primary,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(color: AppColors.primary),
                      ),
                    ),
                    onPressed: _isGettingLocation ? null : _getCurrentLocation,
                    icon: _isGettingLocation
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      _isGettingLocation
                          ? 'Mengambil Lokasi...'
                          : 'Gunakan Lokasi Saat Ini',
                    ),
                  ),
                ),
              ],
            ),

            const Gap(8.0),
            // Input Odometer
            titleLabel('Odometer Awal (KM)', required: true),
            CustomTextField(
              controller: odometerAwalController,
              borderRadius: 8,
              hintText: 'Min. $_minOdometer KM',
              suffixText: 'KM',
              keyboardType: TextInputType.number,
              validator: _validateNumber,
            ),
            const Gap(4.0),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 13,
                  color: AppColors.textSecondary,
                ),
                const Gap(4.0),
                Text(
                  _minOdometer > 0
                      ? 'Odometer kendaraan saat ini: $_minOdometer km'
                      : 'Belum ada data odometer sebelumnya',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Gap(20.0),
            BlocBuilder<StartTripBloc, StartTripState>(
              builder: (context, state) {
                final isLoading = state is StartTripLoading;
                return CustomButton(
                  text: isLoading ? 'Memproses...' : 'Mulai Perjalanan',
                  onPressed: isLoading ? () {} : _handleSubmit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
