import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../blocs/damage_report_bloc.dart';
import '../blocs/damage_report_event.dart';
import '../blocs/damage_report_state.dart';

class DamageReportPage extends StatefulWidget {
  final int tripId;
  final int driverId;
  final int vehicleId;
  final int? currentOdometer;

  const DamageReportPage({
    super.key,
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    this.currentOdometer,
  });

  @override
  State<DamageReportPage> createState() => _DamageReportPageState();
}

class _DamageReportPageState extends State<DamageReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _locationController = TextEditingController();
  final _odometerController = TextEditingController();

  String _operationalStatus = 'Beroperasi';
  String _severity = 'Ringan';
  String _damageType = 'Mesin';
  String? _imagePath;

  static const _operationalStatusOptions = [
    'Beroperasi',
    'Berhenti Aman',
    'Tidak Dapat Beroperasi',
  ];

  static const _severityOptions = ['Ringan', 'Sedang', 'Berat'];

  static const _damageTypeOptions = [
    'Mesin',
    'Ban',
    'Rem',
    'Kelistrikan',
    'Body',
    'Transmisi',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.currentOdometer != null) {
      _odometerController.text = widget.currentOdometer.toString();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _locationController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImagePickerUtil.pick(context);
    if (!mounted || path == null) return;
    setState(() => _imagePath = path);
  }

  void _removeImage() {
    setState(() => _imagePath = null);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<DamageReportBloc>().add(
      SubmitDamageReport(
        tripId: widget.tripId,
        driverId: widget.driverId,
        vehicleId: widget.vehicleId,
        operationalStatus: _operationalStatus,
        severity: _severity,
        damageType: _damageType,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        location: _locationController.text.trim(),
        odometer: int.tryParse(_odometerController.text) ?? 0,
        image: ImagePickerUtil.toFile(_imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DamageReportBloc, DamageReportState>(
      listener: (context, state) {
        if (state is DamageReportSuccess) {
          SnackBarUtil.showSuccess(
            context,
            'Laporan kerusakan berhasil dikirim',
          );
          Navigator.pop(context, true);
        } else if (state is DamageReportError) {
          SnackBarUtil.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: CustomSimpleAppBar(title: 'Laporan Kerusakan'),
        body: BlocBuilder<DamageReportBloc, DamageReportState>(
          builder: (context, state) {
            final isLoading = state is DamageReportLoading;
            return AbsorbPointer(
              absorbing: isLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: CustomCardForm(
                    title: 'Form Laporan Kerusakan',
                    formFields: [
                      titleLabel('Status Operasional', required: true),
                      CustomDropdown(
                        value: _operationalStatus,
                        items: _operationalStatusOptions,
                        onChanged: (v) => setState(() => _operationalStatus = v!),
                      ),
                      const SizedBox(height: 16),
                  
                      titleLabel('Tingkat Keparahan', required: true),
                      CustomDropdown(
                        value: _severity,
                        items: _severityOptions,
                        onChanged: (v) => setState(() => _severity = v!),
                      ),
                      const SizedBox(height: 16),
                  
                      titleLabel('Jenis Kerusakan', required: true),
                      CustomDropdown(
                        value: _damageType,
                        items: _damageTypeOptions,
                        onChanged: (v) => setState(() => _damageType = v!),
                      ),
                      const SizedBox(height: 16),
                  
                      titleLabel('Catatan', required: false),
                      CustomTextField(
                        controller: _noteController,
                        maxLines: 3,
                        hintText: 'Deskripsikan kerusakan secara singkat',
                      ),
                      const SizedBox(height: 16),
                  
                      titleLabel('Lokasi', required: true),
                      CustomTextField(
                        controller: _locationController,
                        hintText: 'Contoh: Jalan Raya No. 123, Jakarta',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Lokasi wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                  
                      titleLabel('Odometer (KM)', required: true),
                      CustomTextField(
                        controller: _odometerController,
                        keyboardType: TextInputType.number,
                        hintText: 'Contoh: 130',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Odometer wajib diisi';
                          }
                          if (int.tryParse(v) == null) {
                            return 'Harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                  
                      titleLabel('Foto Bukti', required: true),
                      ImagePickerWidget(
                        onPickImage: _pickImage,
                        onRemoveImage: _removeImage,
                        imagePath: _imagePath,
                      ),
                      const SizedBox(height: 24),
                  
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Kirim Laporan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
