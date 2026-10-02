import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../utils/location_util.dart';


class EndTripForm extends StatefulWidget {
  final GlobalKey<FormState>? formStateKey;
  final int odometerAwal;
  final Duration duration;
  final File? dokumentasiFoto;
  final String startLocation;

  const EndTripForm({
    super.key,
    required this.formStateKey,
    required this.odometerAwal,
    required this.duration,
    required this.startLocation,
    this.dokumentasiFoto,
  });

  @override
  State<EndTripForm> createState() => _EndTripFormState();
}

class _EndTripFormState extends State<EndTripForm> {
  final formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  final odometerAkhirController = TextEditingController();
  final titikAkhirController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    odometerAkhirController.dispose();
    titikAkhirController.dispose();
    super.dispose();
  }

  String getTitikAkhir() => titikAkhirController.text.trim();
  bool _isGettingLocation = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      final position = await LocationUtil.getCurrentLocation(context);
      if (position != null && mounted) {
        final locationName = await LocationUtil.getLocationName(
          position.latitude,
          position.longitude,
          context,
        );
        if (mounted && locationName.isNotEmpty) {
          titikAkhirController.text = locationName;
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  String getNote() {
    final note = noteController.text.trim();
    return note.isEmpty ? '' : note;
  }

  int getOdometerAkhir() {
    try {
      return int.parse(odometerAkhirController.text.trim());
    } on FormatException {
      return 0;
    }
  }

  GlobalKey<FormState> getFormKey() => formKey;

  double getKecepatanRataRata(int odometerAkhir) {
    try {
      final jarak = odometerAkhir - widget.odometerAwal;
      final durationInHours = widget.duration.inMinutes / 60;
      if (durationInHours == 0) return 0.0;
      final averageSpeed = jarak / durationInHours;
      return averageSpeed;
    } catch (e) {
      return 0.0;
    }
  }

  String getFormattedAverageSpeed(int odometerAkhir) {
    final speed = getKecepatanRataRata(odometerAkhir);
    return '${speed.toStringAsFixed(1)} km/jam';
  }

  String? _validateEmpty(String? value) {
    return value?.isEmpty ?? true ? 'Wajib diisi' : null;
  }

  String? _validateOdometerAkhir(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Odometer akhir wajib diisi';
    }
    try {
      final odometerAkhir = int.parse(value!.trim());
      if (odometerAkhir < 0) {
        return 'Odometer akhir tidak boleh negatif';
      }
      if (odometerAkhir < widget.odometerAwal) {
        return 'Tidak boleh kurang dari ${widget.odometerAwal} KM';
      }

      return null;
    } on FormatException {
      return 'Odometer akhir harus berupa angka';
    } catch (e) {
      return 'Terjadi kesalahan: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: CustomCardForm(
        title: 'Form Akhir Perjalanan',
        formFields: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INPUT TITIK AKHIR
              titleLabel('Titik Akhir', required: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    borderRadius: 8,
                    maxLines: 2,
                    minLines: 1,
                    controller: titikAkhirController,
                    hintText: 'Tempat, Kota, Provinsi',
                    validator: _validateEmpty,
                  ),
                  const Gap(8.0),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(
                          AppColors.primary,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onPressed: _isGettingLocation
                          ? null
                          : _getCurrentLocation,
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
              const Gap(4.0),

              // INPUT ODOMETER AKHIR PERJALANAN
              titleLabel('Odometer Akhir (KM)', required: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: odometerAkhirController,
                    borderRadius: 8,
                    prefixIcon: Icons.speed_rounded,
                    suffixText: 'KM',
                    hintText: '0 KM',
                    keyboardType: TextInputType.number,
                    validator: _validateOdometerAkhir,
                  ),
                  const Gap(8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.grey400,
                        size: 16,
                      ),
                      Gap(4.0),
                      Text(
                        'Odometer awal: ${widget.odometerAwal} KM',
                        style: const TextStyle(color: AppColors.grey400),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(4.0),

              // CATATAN PERJALANAN
              titleLabel('Catatan Perjalanan', required: false),
              CustomTextField(
                controller: noteController,
                borderRadius: 8,
                hintText: 'Masukkan catatan perjalanan...',
                minLines: 3,
                validator: _validateEmpty,
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
