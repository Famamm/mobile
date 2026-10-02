import 'dart:async';

import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';

import '../../domain/repositories/trip_gps_repository.dart';
import '../blocs/end_trip_bloc.dart';
import '../blocs/cancel_trip_bloc.dart';
import '../services/gps_tracking_service.dart';
import '../utils/trip_active_bloc_listeners.dart';
import '../utils/trip_active_dialog_mixin.dart';
import '../utils/trip_end_submission_service.dart';
import '../widgets/cards/info_location_card.dart';
import '../widgets/cards/trip_duration_card.dart';
import '../widgets/components/button_input_bbm.dart';
import '../widgets/components/button_input_reports.dart';
import '../widgets/components/dialog_manual_location.dart';
import '../widgets/forms/end_trip_form.dart';
import '../widgets/maps/live_location_map.dart';

class TripActivePage extends StatefulWidget {
  final String startLocation;
  final int odometerAwal;
  final String? tripId;
  final DateTime? startTime;

  const TripActivePage({
    super.key,
    required this.odometerAwal,
    required this.startLocation,
    this.tripId,
    this.startTime,
  });

  static String routeName = '/trip-active';

  @override
  State<TripActivePage> createState() => _TripActivePageState();
}

class _TripActivePageState extends State<TripActivePage>
    with TripActiveDialogMixin {
  final GlobalKey _endTripFormKey = GlobalKey();
  final _submissionService = TripEndSubmissionService();
  late DateTime _startTime;
  late Timer _timer;
  Position? _currentLocation;
  Timer? _locationUpdateTimer;
  String? _imagePath;
  int _odometerAkhir = 0;
  bool _isSubmitting = false;
  String? _manualLocationInput;
  GpsTrackingService? _gpsTrackingService;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime ?? DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });

    // Cek lokasi awal
    _getCurrentLocation();
    _gpsTrackingService = GpsTrackingService(
      repository: sl<TripGpsRepository>(),
      tripId: widget.tripId ?? '0',
    )..start();
  }

  @override
  void dispose() {
    _timer.cancel();
    _locationUpdateTimer?.cancel();
    _gpsTrackingService?.stop();
    _gpsTrackingService?.dispose();
    super.dispose();
  }

  Duration _getDuration() => DateTime.now().difference(_startTime);

  Future<bool> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever)
        return false;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      if (mounted) setState(() => _currentLocation = position);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _ensureLocationAvailable() async {
    // Kalau sudah ada lokasi GPS, langsung pakai
    if (_currentLocation != null) return true;

    // Coba ambil ulang
    final success = await _getCurrentLocation();
    if (success) return true;

    // Gagal → tampilkan dialog input manual
    if (!mounted) return false;
    final manual = await ManualLocationDialog.show(
      context,
      initialValue: _manualLocationInput,
    );

    if (manual == null || manual.isEmpty) return false;

    setState(() => _manualLocationInput = manual);
    return true;
  }

  Future<void> _pickPhoto() async {
    final path = await ImagePickerUtil.pick(context);
    if (!mounted || path == null) return;
    setState(() => _imagePath = path);
  }

  void _removePhoto() {
    setState(() => _imagePath = null);
  }

  @override
  void onEndTripConfirmed(BuildContext context) {
    setState(() => _isSubmitting = true);
    _handleEndTripSubmit(context);
  }

  void _handleEndTripSubmit(BuildContext context) async {
    try {
      // Cek lokasi — kalau gagal, muncul dialog input manual
      final hasLocation = await _ensureLocationAvailable();
      if (!hasLocation) {
        setState(() => _isSubmitting = false);
        SnackBarUtil.showError(
          context,
          'Lokasi wajib diisi untuk mengakhiri perjalanan',
        );
        return;
      }

      if (!mounted) return;

      final formState = _endTripFormKey.currentState as dynamic;

      setState(() => _odometerAkhir = formState.getOdometerAkhir());

      await _submissionService.submitEndTrip(
        context: context,
        data: EndTripSubmissionData(
          formKey: formState.getFormKey(),
          titikAkhir: formState.getTitikAkhir(),
          selectedPhoto: ImagePickerUtil.toFile(_imagePath)!,
          duration: _getDuration(),
          odometerAwal: widget.odometerAwal,
          tripId: widget.tripId ?? '0',
          startLocation: widget.startLocation,
          getOdometerAkhir: () => formState.getOdometerAkhir(),
          getNote: () => formState.getNote(),
          getKecepatanRataRata: (odometer) =>
              formState.getKecepatanRataRata(odometer),
        ),
        currentLocation: _currentLocation,
        onError: (errorMsg) {
          setState(() => _isSubmitting = false);
          SnackBarUtil.showError(context, errorMsg);
        },
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      SnackBarUtil.showError(context, 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EndTripBloc>()),
        BlocProvider(create: (_) => sl<CancelTripBloc>()),
      ],
      child: Builder(
        builder: (context) {
          return TripActiveBlocListeners(
            getOdometerAkhir: () => _odometerAkhir,
            onSubmissionStateChange: (isSubmitting) {
              setState(() => _isSubmitting = isSubmitting);
            },
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop)
                  showExitConfirmation(context, widget.tripId ?? '0');
              },
              child: Scaffold(
                appBar: CustomSimpleAppBar(
                  title: 'Perjalanan Aktif',
                  onBackPressed: () =>
                      showExitConfirmation(context, widget.tripId ?? '0'),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TripDurationCard(
                                duration: _getDuration(),
                                startTime: _startTime,
                              ),
                              const Gap(12.0),
                              TripLiveMap(
                                currentLocation: _currentLocation,
                                startLocation: widget.startLocation,
                                trackedPoints:
                                    _gpsTrackingService?.trackedPoints,
                              ),
                              const Gap(12.0),
                              InfoLocationCard(
                                startLocation: widget.startLocation,
                              ),
                              const Gap(12.0),
                              ButtonInputBbm(
                                tripId: widget.tripId,
                                currentOdometer: widget.odometerAwal,
                              ),
                              const Gap(12.0),
                              ButtonInputReports(
                                tripId: int.tryParse(widget.tripId ?? '0') ?? 0,
                                driverId:
                                    int.tryParse(
                                      sl<TokenService>()
                                              .getDriverId()
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                                vehicleId:
                                    int.tryParse(
                                      sl<TokenService>()
                                              .getActiveVehicleId()
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                                currentOdometer: widget
                                    .odometerAwal, // atau odometer terkini
                              ),
                              const Gap(12.0),
                              const Text(
                                'Log Perjalanan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(16.0),
                              CustomCardForm(
                                title: 'Dokumentasi Foto Perjalanan',
                                formFields: [
                                  titleLabel('Foto Dokumentasi', required: true),
                                  ImagePickerWidget(
                                    onPickImage: _pickPhoto,
                                    onRemoveImage: _removePhoto,
                                    imagePath: _imagePath,
                                    height: 140,
                                    innerTitle: 'Ambil Dokumentasi Foto',
                                  ),
                                ],
                              ),
                              const Gap(12.0),
                              EndTripForm(
                                key: _endTripFormKey,
                                formStateKey: null,
                                duration: _getDuration(),
                                odometerAwal: widget.odometerAwal,
                                dokumentasiFoto: ImagePickerUtil.toFile(
                                  _imagePath,
                                ),
                                startLocation: widget.startLocation,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: CustomButton(
                        text: _isSubmitting
                            ? 'Memproses...'
                            : 'Akhiri Perjalanan',
                        color: _isSubmitting
                            ? AppColors.grey300
                            : AppColors.error,
                        textColor: _isSubmitting
                            ? AppColors.textSecondary
                            : AppColors.white,
                        onPressed: _isSubmitting
                            ? null
                            : () => showEndTripConfirmation(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
