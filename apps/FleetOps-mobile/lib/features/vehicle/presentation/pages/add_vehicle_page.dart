import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_state.dart';
import 'package:fleetops_mobile/injection_container.dart';
import '../blocs/add_vehicle_bloc.dart';
import '../blocs/add_vehicle_event.dart';
import '../blocs/add_vehicle_state.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  static const String routeName = '/add-vehicle';

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final formKey = GlobalKey<FormState>();
  final vehicleNameController = TextEditingController();
  final platNomorController = TextEditingController();
  final tahunPembuatanController = TextEditingController();
  final odometerController = TextEditingController();
  final muatanMaxController = TextEditingController();

  String selectedTipe = 'Lainnya';
  String selectedStatus = 'Active';
  String selectedTipeBensin = 'Diesel';
  String? selectedImagePath;
  late int organizationId;

  @override
  void initState() {
    super.initState();
    _initializeOrganizationId();
  }

  void _initializeOrganizationId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      print(
        '[ADD VEHICLE] authState.organizationId = ${authState.organizationId}',
      );
      organizationId =
          authState.organizationId ??
          sl<TokenService>().getOrganizationId() ??
          0;
    } else {
      print(
        '[ADD VEHICLE] AuthState bukan AuthSuccess: ${authState.runtimeType}',
      );
      organizationId = sl<TokenService>().getOrganizationId() ?? 0;
    }
    print('[ADD VEHICLE] organizationId yang dipakai: $organizationId');
  }

  Future<void> _pickImage() async {
    if (!mounted) return;
    final path = await ImagePickerUtil.pick(context);
    if (path != null && mounted) {
      setState(() => selectedImagePath = path);
    }
  }

  int _mapTipeBensinToInt(String tipeBensin) {
    switch (tipeBensin) {
      case 'Diesel':
        return 0;
      case 'Bensin':
        return 1;
      default:
        return 0;
    }
  }

  void _handleSubmit() {
    if (!formKey.currentState!.validate()) {
      SnackBarUtil.showError(
        context,
        'Pastikan semua field terisi dengan benar',
      );
      return;
    }

    try {
      final tahun = int.parse(tahunPembuatanController.text.trim());
      final odometer = int.parse(odometerController.text.trim());
      final muatanMax = int.parse(muatanMaxController.text.trim());

      context.read<AddVehicleBloc>().add(
        AddVehicleSubmitted(
          organizationId: organizationId,
          vehicleName: vehicleNameController.text.trim(),
          platNomor: platNomorController.text.trim().toUpperCase(),
          tahunPembuatan: tahun,
          odometer: odometer,
          tipe: selectedTipe,
          status: selectedStatus,
          muatanMax: muatanMax,
          tipeBensin: _mapTipeBensinToInt(selectedTipeBensin),
          imagePath: selectedImagePath,
        ),
      );
    } on FormatException {
      SnackBarUtil.showError(context, 'Input angka tidak valid');
    } catch (e) {
      SnackBarUtil.showError(context, 'Terjadi kesalahan: $e');
    }
  }

  String? _validateRequired(String? value) {
    return value?.isEmpty ?? true ? 'Wajib diisi' : null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value?.isEmpty ?? true) {
      return '$fieldName wajib diisi';
    }
    try {
      int.parse(value!);
      return null;
    } catch (e) {
      return '$fieldName harus berupa angka';
    }
  }

  @override
  void dispose() {
    vehicleNameController.dispose();
    platNomorController.dispose();
    tahunPembuatanController.dispose();
    odometerController.dispose();
    muatanMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar(title: 'Tambah Kendaraan'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Input Kendaraan Baru',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            BlocListener<AddVehicleBloc, AddVehicleState>(
              listener: (context, state) async {
                if (state is AddVehicleSuccess) {
                  await sl<TokenService>().saveActiveVehicle(
                    vehicleId: state.vehicle.vehicleId,
                    vehicleName: state.vehicle.vehicleName,
                    platNomor: state.vehicle.platNomor,
                    odometer: state.vehicle.odometer,
                  );
                  if (context.mounted) {
                    SnackBarUtil.showSuccess(
                      context,
                      'Kendaraan berhasil ditambahkan',
                    );
                    Navigator.pop(context);
                  }
                } else if (state is AddVehicleError) {
                  SnackBarUtil.showError(context, state.message);
                }
              },
              child: BlocBuilder<AddVehicleBloc, AddVehicleState>(
                builder: (context, state) {
                  if (state is AddVehicleLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCardForm(
                            title: 'Informasi Kendaraan',
                            formFields: [
                              titleLabel('Nama Kendaraan', required: true),
                              CustomTextField(
                                controller: vehicleNameController,
                                hintText: 'Misal: Truk Ekspor 1',
                                capitalizeWords: true,
                                validator: _validateRequired,
                                borderRadius: 8,
                              ),
                              SizedBox(height: 8),

                              // Plat Nomor - hapus Expanded
                              titleLabel('Plat Nomor', required: true),
                              CustomTextField(
                                controller: platNomorController,
                                hintText: 'Misal: AB 1234 CD',
                                allCaps: true,
                                validator: _validateRequired,
                                borderRadius: 8,
                              ),
                              SizedBox(height: 8),

                              // Tahun & Odometer - pakai Expanded di dalam Row
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
                                          controller: tahunPembuatanController,
                                          hintText: '2020',
                                          keyboardType: TextInputType.number,
                                          borderRadius: 8,
                                          validator: (v) =>
                                              _validateNumber(v, 'Tahun'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ), // width bukan height
                                  Expanded(
                                    child: Column(
                                      children: [
                                        titleLabel(
                                          'Odometer (KM)',
                                          required: true,
                                        ),
                                        CustomTextField(
                                          controller: odometerController,
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
                              SizedBox(height: 8),

                              titleLabel('Tipe Kendaraan', required: true),
                              CustomDropdown(
                                value: selectedTipe,
                                borderRadius: 8,
                                items: [
                                  'Truk Kontainer',
                                  'Truk Tangki',
                                  'Mobil Penumpang',
                                  'Mobil Bak',
                                  'Mobil Box',
                                  'Lainnya',
                                ],
                                onChanged: (value) {
                                  setState(
                                    () => selectedTipe = value ?? 'Lainnya',
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          CustomCardForm(
                            title: 'Spesifikasi',
                            formFields: [
                              // Muatan Max
                              titleLabel(
                                'Muatan Maksimal (Kg)',
                                required: true,
                              ),
                              CustomTextField(
                                controller: muatanMaxController,
                                hintText: '5000',
                                keyboardType: TextInputType.number,
                                borderRadius: 8,
                                validator: (v) => _validateNumber(v, 'Muatan'),
                              ),
                              SizedBox(height: 8),

                              titleLabel('Tipe Bahan Bakar', required: true),
                              FuelTypeToggle(
                                selected: selectedTipeBensin,
                                onChanged: (v) =>
                                    setState(() => selectedTipeBensin = v),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          CustomCardForm(
                            title: 'Foto Kendaraan',
                            formFields: [
                              titleLabel('Foto Kendaraan', required: true),
                              ImagePickerWidget(
                                imagePath: selectedImagePath,
                                onPickImage: _pickImage,
                                onRemoveImage: () =>
                                    setState(() => selectedImagePath = null),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),

                          // Submit Button
                          CustomButton(
                            text: 'Tambah Kendaraan',
                            onPressed: _handleSubmit,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
