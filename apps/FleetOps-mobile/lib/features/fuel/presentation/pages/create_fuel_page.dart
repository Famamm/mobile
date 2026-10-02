import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import '../widgets/fuel_info_card.dart';
import '../widgets/total_biaya_field.dart';
import '../widgets/fuel_location_card.dart';
import '../bloc/fuel_bloc.dart';
import '../bloc/fuel_event.dart';
import '../../../../injection_container.dart';

class CreateFuelPage extends StatefulWidget {
  final String vehicleId;
  final String vehicleName;
  final String tipeBensin;
  final int? currentOdometer;

  const CreateFuelPage({
    Key? key,
    required this.vehicleId,
    required this.vehicleName,
    this.currentOdometer,
    this.tipeBensin = '',
  }) : super(key: key);

  @override
  State<CreateFuelPage> createState() => _CreateFuelPageState();
}

const _bensinTypes = [
  'Pertalite',
  'Pertamax (RON 92)',
  'Pertamax Green 95',
  'Pertamax Turbo (RON 98)',
];
const _dieselTypes = ['BioSolar', 'Dexlite', 'Pertamina Dex'];

class _CreateFuelPageState extends State<CreateFuelPage> {
  final _formKey = GlobalKey<FormState>();
  final _jmlLiterController = TextEditingController();
  final _odometerController = TextEditingController();
  final _catatanController = TextEditingController();

  String? _selectedFuelType;
  int? _selectedFuelPricePerLiter;
  String? _imagePath;

  // ===== STATE LOKASI =====
  double? _latitude;
  double? _longitude;
  String? _address;
  bool _isLoadingLocation = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    context.read<FuelBloc>().add(const LoadFuelPricesEvent());
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      // 1. Cek service lokasi aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Layanan lokasi tidak aktif. Aktifkan GPS Anda.';
      }

      // 2. Cek & minta permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen. Buka pengaturan aplikasi.';
      }

      // 3. Ambil posisi
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // 4. Reverse geocoding
      String? address;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          address = [
            p.subLocality,
            p.locality,
            p.subAdministrativeArea,
            p.administrativeArea,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
        }
      } catch (_) {
        address = null;
      }

      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _address =
            address ??
            'Koordinat: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
        _isLoadingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationError = e.toString();
        _isLoadingLocation = false;
      });
    }
  }

  double get _totalBiaya {
    final liter = double.tryParse(_jmlLiterController.text) ?? 0;
    return liter * (_selectedFuelPricePerLiter ?? 0);
  }

  @override
  void dispose() {
    _jmlLiterController.dispose();
    _odometerController.dispose();
    _catatanController.dispose();
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

  void _submitFuelForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFuelType == null) {
      SnackBarUtil.showError(context, 'Pilih jenis BBM terlebih dahulu');
      return;
    }

    final tokenService = sl<TokenService>();
    final organizationId = tokenService.getOrganizationId() ?? 0;

    context.read<FuelBloc>().add(
      CreateFuelEvent(
        vehicleId: int.parse(widget.vehicleId),
        organizationId: organizationId,
        fuelType: _selectedFuelType!,
        jmlLiter: double.parse(_jmlLiterController.text.trim()),
        odometerIsi: int.parse(_odometerController.text.trim()),
        catatan: _catatanController.text.trim(),
        fuelPhoto: ImagePickerUtil.toFile(_imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar(title: 'Tambah Pencatatan BBM'),
      body: BlocListener<FuelBloc, FuelState>(
        listener: (context, state) {
          if (state is FuelCreateSuccess) {
            SnackBarUtil.showSuccess(context, 'Data BBM berhasil disimpan');
            Navigator.pop(context, true);
          } else if (state is FuelError) {
            SnackBarUtil.showError(context, state.message);
          }
        },
        child: BlocBuilder<FuelBloc, FuelState>(
          builder: (context, state) {
            final isLoading = state is FuelLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FuelInfoCard(vehicleName: widget.vehicleName),
                    const SizedBox(height: 16),
                    CustomCardForm(
                      title: 'Detail Pengisian BBM',
                      formFields: [
                        // WIDGET LOKASI PENGISIAN
                        titleLabel('Lokasi Pengisian', required: true),
                        FuelLocationCard(
                          address: _address,
                          latitude: _latitude,
                          longitude: _longitude,
                          isLoading: _isLoadingLocation,
                          errorMessage: _locationError,
                          onRefresh: _getCurrentLocation,
                        ),
                        // Jumlah BBM
                        SizedBox(height: 8),
                        titleLabel('Jumlah BBM (Liter)', required: true),
                        CustomTextField(
                          controller: _jmlLiterController,
                          hintText: '0 Liter',
                          borderRadius: 8,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Jumlah BBM harus diisi';
                            }
                            if (double.tryParse(v) == null) {
                              return 'Masukkan angka yang valid';
                            }
                            if (double.parse(v) <= 0) {
                              return 'Jumlah harus lebih dari 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Odometer
                        titleLabel('Odometer (KM)', required: true),
                        CustomTextField(
                          controller: _odometerController,
                          hintText: '${widget.currentOdometer ?? 0} KM',
                          borderRadius: 8,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Odometer harus diisi';
                            }
                            if (int.tryParse(v) == null) {
                              return 'Masukkan angka yang valid';
                            }
                            if (widget.currentOdometer != null &&
                                int.parse(v) < widget.currentOdometer!) {
                              return 'Odometer tidak boleh kurang dari ${widget.currentOdometer} KM';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Jenis BBM dropdown dari API
                        titleLabel('Jenis BBM', required: true),
                        _buildFuelTypeDropdown(state),
                        const SizedBox(height: 8),

                        // Total Biaya (readonly)
                        titleLabel('Total Biaya (Rp)', required: true),
                        TotalBiayaField(
                          selectedFuelPricePerLiter: _selectedFuelPricePerLiter,
                          jmlLiterText: _jmlLiterController.text,
                          totalBiaya: _totalBiaya,
                        ),
                        const SizedBox(height: 4),

                        // Foto struk
                        titleLabel('Foto Struk', required: true),
                        ImagePickerWidget(
                          imagePath: _imagePath,
                          onPickImage: _pickImage,
                          onRemoveImage: _removeImage,
                        ),
                        const SizedBox(height: 8),

                        // Catatan
                        titleLabel('Catatan Tambahan', required: false),
                        CustomTextField(
                          controller: _catatanController,
                          hintText: 'Masukan catatan tambahan..',
                          borderRadius: 8,
                          maxLines: 3,
                          minLines: 3,
                        ),
                      ],
                    ),

                    // Tombol simpan
                    const SizedBox(height: 24),
                    CustomButton(
                      isLoading: isLoading,
                      text: 'Simpan Data BBM',
                      onPressed: _submitFuelForm,
                      color: AppColors.primary,
                      textColor: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      icon: Icons.save,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFuelTypeDropdown(FuelState state) {
    if (state is FuelLoading) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              'Memuat daftar BBM...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final allPrices = state is FuelPricesLoaded ? state.prices : [];

    final allowedTypes = widget.tipeBensin.toLowerCase() == 'diesel'
        ? _dieselTypes
        : widget.tipeBensin.toLowerCase() == 'bensin'
        ? _bensinTypes
        : null;

    final filteredPrices = allowedTypes == null
        ? allPrices
        : allPrices.where((p) => allowedTypes.contains(p.fuelType)).toList();

    final List<String> fuelTypeItems = filteredPrices
        .map((p) => p.fuelType as String)
        .toList();

    return CustomDropdown(
      value: _selectedFuelType ?? '',
      items: fuelTypeItems,
      borderRadius: 8,
      onChanged: (val) {
        if (val == null || val.isEmpty) return;
        final selected = filteredPrices.firstWhere((p) => p.fuelType == val);
        setState(() {
          _selectedFuelType = val;
          _selectedFuelPricePerLiter = selected.pricePerLiter;
        });
      },
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Pilih jenis BBM';
        }
        return null;
      },
    );
  }
}
