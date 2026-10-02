import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:core/core.dart';

import '../../domain/entities/vehicle.dart';
import '../blocs/update_vehicle_bloc.dart';
import '../blocs/update_vehicle_event.dart';
import '../blocs/update_vehicle_state.dart';

class AdminEditVehiclePage extends StatefulWidget {
  final Vehicle vehicle;

  const AdminEditVehiclePage({super.key, required this.vehicle});

  @override
  State<AdminEditVehiclePage> createState() => _AdminEditVehiclePageState();
}

class _AdminEditVehiclePageState extends State<AdminEditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _vehicleNameController;
  late final TextEditingController _platNomorController;
  late final TextEditingController _tahunController;
  late final TextEditingController _odometerController;
  late final TextEditingController _muatanMaxController;

  late String _selectedTipe;
  late String _selectedTipeBensin;
  String? _newImagePath;

  @override
  void initState() {
    super.initState();
    _vehicleNameController = TextEditingController(
      text: widget.vehicle.vehicleName,
    );
    _platNomorController = TextEditingController(
      text: widget.vehicle.platNomor,
    );
    _tahunController = TextEditingController(
      text: widget.vehicle.tahunPembuatan == 0
          ? ''
          : widget.vehicle.tahunPembuatan.toString(),
    );
    _odometerController = TextEditingController(
      text: widget.vehicle.odometer.toString(),
    );
    _muatanMaxController = TextEditingController(
      text: widget.vehicle.muatanMax.toString(),
    );

    _selectedTipe = _normalizeTipe(widget.vehicle.tipe);
    final bensinLower = widget.vehicle.tipeBensin.toLowerCase();
    _selectedTipeBensin =
        (bensinLower.contains('solar') || bensinLower.contains('diesel'))
        ? 'Diesel'
        : 'Bensin';
  }

  String _normalizeTipe(String tipe) {
    final t = tipe.toLowerCase();
    if (t.contains('kontainer')) return 'Truk Kontainer';
    if (t.contains('tangki')) return 'Truk Tangki';
    if (t.contains('penumpang')) return 'Mobil Penumpang';
    if (t.contains('bak')) return 'Mobil Bak';
    if (t.contains('box')) return 'Mobil Box';
    if (t.contains('truk') || t.contains('truck')) return 'Truk Kontainer';
    if (t.contains('mobil')) return 'Mobil Penumpang';
    return 'Lainnya';
  }

  @override
  void dispose() {
    _vehicleNameController.dispose();
    _platNomorController.dispose();
    _tahunController.dispose();
    _odometerController.dispose();
    _muatanMaxController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!mounted) return;
    final path = await ImagePickerUtil.pick(context);
    if (path != null && mounted) setState(() => _newImagePath = path);
  }

  int _mapTipeBensin(String tipeBensin) => tipeBensin == 'Diesel' ? 0 : 1;

  String? _validateRequired(String? value) =>
      value?.isEmpty ?? true ? 'Wajib diisi' : null;

  String? _validateNumber(String? value, String fieldName) {
    if (value?.isEmpty ?? true) return '$fieldName wajib diisi';
    if (int.tryParse(value!) == null) return '$fieldName harus berupa angka';
    return null;
  }

  void _handleSubmit(BuildContext ctx) {
    if (!_formKey.currentState!.validate()) {
      SnackBarUtil.showError(ctx, 'Pastikan semua field terisi dengan benar');
      return;
    }

    showDialog(
      context: ctx,
      builder: (_) => ConfirmationDialog(
        iconData: Icons.edit_outlined,
        iconColor: AppColors.primary,
        iconBgColor: AppColors.bgprimary,
        title: 'Edit Kendaraan',
        message: 'Apakah Anda yakin ingin mengubah data kendaraan ini?',
        confirmText: 'Ya, Edit Kendaraan',
        onConfirm: () => _dispatchUpdate(ctx),
      ),
    );
  }

  void _dispatchUpdate(BuildContext ctx) {
    final tahun =
        int.tryParse(_tahunController.text.trim()) ??
        widget.vehicle.tahunPembuatan;
    final odometer =
        int.tryParse(_odometerController.text.trim()) ??
        widget.vehicle.odometer;
    final muatanMax =
        int.tryParse(_muatanMaxController.text.trim()) ??
        widget.vehicle.muatanMax;

    ctx.read<UpdateVehicleBloc>().add(
      UpdateVehicleSubmitted(
        vehicleId: widget.vehicle.vehicleId,
        organizationId:
            widget.vehicle.organizationId ??
            sl<TokenService>().getOrganizationId() ??
            0,
        vehicleName: _vehicleNameController.text.trim(),
        platNomor: _platNomorController.text.trim().toUpperCase(),
        tahunPembuatan: tahun,
        odometer: odometer,
        tipe: _selectedTipe,
        status: widget.vehicle.status,
        muatanMax: muatanMax,
        tipeBensin: _mapTipeBensin(_selectedTipeBensin),
        imagePath: _newImagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UpdateVehicleBloc>(),
      child: Scaffold(
        appBar: CustomSimpleAppBar(title: 'Edit Kendaraan'),
        body: BlocListener<UpdateVehicleBloc, UpdateVehicleState>(
          listener: (context, state) {
            if (state is UpdateVehicleSuccess) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SuccessDialog(
                  title: 'Berhasil Disimpan',
                  message: 'Data kendaraan berhasil diperbarui.',
                  onOk: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              );
            } else if (state is UpdateVehicleError) {
              SnackBarUtil.showError(context, state.message);
            }
          },
          child: BlocBuilder<UpdateVehicleBloc, UpdateVehicleState>(
            builder: (context, state) {
              if (state is UpdateVehicleLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Edit Data Kendaraan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomCardForm(
                              title: 'Informasi Kendaraan',
                              formFields: [
                                titleLabel('Nama Kendaraan', required: true),
                                CustomTextField(
                                  controller: _vehicleNameController,
                                  hintText: 'Misal: Truk Ekspor 1',
                                  capitalizeWords: true,
                                  validator: _validateRequired,
                                  borderRadius: 8,
                                ),
                                const SizedBox(height: 8),
                                titleLabel('Plat Nomor', required: true),
                                CustomTextField(
                                  controller: _platNomorController,
                                  hintText: 'Misal: AB 1234 CD',
                                  allCaps: true,
                                  validator: _validateRequired,
                                  borderRadius: 8,
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          titleLabel(
                                            'Tahun Pembuatan',
                                            required: true,
                                          ),
                                          CustomTextField(
                                            controller: _tahunController,
                                            hintText: '2020',
                                            keyboardType: TextInputType.number,
                                            borderRadius: 8,
                                            validator: (v) =>
                                                _validateNumber(v, 'Tahun'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          titleLabel(
                                            'Odometer (KM)',
                                            required: true,
                                          ),
                                          CustomTextField(
                                            controller: _odometerController,
                                            hintText: '0',
                                            keyboardType: TextInputType.number,
                                            borderRadius: 8,
                                            validator: (v) =>
                                                _validateNumber(v, 'Odometer'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                titleLabel('Tipe Kendaraan', required: true),
                                CustomDropdown(
                                  value: _selectedTipe,
                                  borderRadius: 8,
                                  items: const [
                                    'Truk Kontainer',
                                    'Truk Tangki',
                                    'Mobil Penumpang',
                                    'Mobil Bak',
                                    'Mobil Box',
                                    'Lainnya',
                                  ],
                                  onChanged: (v) => setState(
                                    () => _selectedTipe = v ?? 'Lainnya',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomCardForm(
                              title: 'Spesifikasi',
                              formFields: [
                                titleLabel(
                                  'Muatan Maksimal (Kg)',
                                  required: true,
                                ),
                                CustomTextField(
                                  controller: _muatanMaxController,
                                  hintText: '5000',
                                  keyboardType: TextInputType.number,
                                  borderRadius: 8,
                                  validator: (v) =>
                                      _validateNumber(v, 'Muatan'),
                                ),
                                const SizedBox(height: 8),

                                titleLabel('Tipe Bahan Bakar', required: true),
                                FuelTypeToggle(
                                  selected: _selectedTipeBensin,
                                  onChanged: (v) =>
                                      setState(() => _selectedTipeBensin = v),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomCardForm(
                              title: 'Foto Kendaraan',
                              formFields: [
                                titleLabel('Foto Kendaraan', required: true),
                                ImagePickerWidget(
                                  imagePath: _newImagePath,
                                  onPickImage: _pickImage,
                                  onRemoveImage: () =>
                                      setState(() => _newImagePath = null),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Simpan Kendaraan',
                              onPressed: () => _handleSubmit(context),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
