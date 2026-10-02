import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../blocs/create_driver_bloc.dart';
import '../blocs/create_driver_event.dart';
import '../blocs/create_driver_state.dart';

class AdminAddDriverPage extends StatefulWidget {
  const AdminAddDriverPage({super.key});

  @override
  State<AdminAddDriverPage> createState() => _AdminAddDriverPageState();
}

class _AdminAddDriverPageState extends State<AdminAddDriverPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedLicenseType = 'SIM A';
  String? _licenseExpiry;
  String? _profileImagePath;
  String? _licenseImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isProfile) async {
    if (!mounted) return;
    final path = await ImagePickerUtil.pick(context);
    if (path != null && mounted) {
      setState(() {
        if (isProfile) {
          _profileImagePath = path;
        } else {
          _licenseImagePath = path;
        }
      });
    }
  }

  Widget _buildImagePicker({
    required bool isProfile,
    required String? imagePath,
  }) {
    return ImagePickerWidget(
      imagePath: imagePath,
      onPickImage: () => _pickImage(isProfile),
      onRemoveImage: () => setState(() {
        if (isProfile) {
          _profileImagePath = null;
        } else {
          _licenseImagePath = null;
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateDriverBloc>(),
      child: BlocListener<CreateDriverBloc, CreateDriverState>(
        listener: (context, state) {
          if (state is CreateDriverSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => DriverCredentialsDialog(
                username: state.generatedUsername,
                password: state.generatedPassword,
                onOk: () => Navigator.of(context).pop(true),
              ),
            );
          } else if (state is CreateDriverError) {
            SnackBarUtil.showError(context, state.message);
          }
        },
        child: Scaffold(
          appBar: CustomSimpleAppBar(title: 'Tambah Pengguna Baru'),
          backgroundColor: AppColors.backgroundLight,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Input Data Pengguna',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Lengkapi formulir dibawah ini untuk menambahkan pengguna baru',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Informasi Pengguna card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pengguna',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        titleLabel('Unggah Foto Pengguna', required: true),
                        _buildImagePicker(
                          isProfile: true,
                          imagePath: _profileImagePath,
                        ),
                        const SizedBox(height: 8),
                        titleLabel('Nama Lengkap', required: true),
                        CustomTextField(
                          hintText: 'Masukkan nama lengkap',
                          controller: _nameController,
                          borderRadius: 8,
                          validator: (v) =>
                              v?.isEmpty == true ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 8),
                        titleLabel('Alamat', required: true),
                        CustomTextField(
                          hintText: 'Desa, Kecamatan, Kabupaten/Kota',
                          controller: _addressController,
                          borderRadius: 8,
                          validator: (v) =>
                              v?.isEmpty == true ? 'Wajib diisi' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Informasi SIM akan tampil jika role driver, untuk fleet manager tidak perlu mengisi SIM
                  // Informasi SIM card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi SIM',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        titleLabel('Jenis SIM', required: true),
                        CustomDropdown(
                          borderRadius: 8,
                          value: _selectedLicenseType,
                          items: [
                            'SIM A',
                            'SIM B1 Umum',
                            'SIM B2 Umum',
                            'SIM C',
                            'SIM D'
                          ],
                          onChanged: (v) => setState(
                              () => _selectedLicenseType = v ?? 'SIM A'),
                        ),
                        const SizedBox(height: 16),
                        titleLabel('Tanggal Berakhir SIM', required: true),
                        CustomDatePickerField(
                          value: _licenseExpiry,
                          onDateSelected: (date) {
                            setState(() {
                              _licenseExpiry =
                                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        titleLabel('Unggah Foto SIM', required: true),
                        _buildImagePicker(
                          isProfile: false,
                          imagePath: _licenseImagePath,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<CreateDriverBloc, CreateDriverState>(
                      builder: (context, state) {
                        final isLoading = state is CreateDriverLoading;

                        return CustomButton(
                          text: 'Tambah Pengguna',
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_licenseExpiry == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Tanggal berakhir SIM wajib diisi')),
                                      );
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (_) => ConfirmationDialog(
                                        iconData: Icons.person_add_outlined,
                                        iconColor: AppColors.primary,
                                        iconBgColor: AppColors.bgprimary,
                                        title: 'Tambah Pengguna Baru',
                                        message:
                                            'Apakah Anda yakin ingin menambahkan pengguna ini?',
                                        confirmText: 'Ya, Tambah',
                                        onConfirm: () {
                                          context.read<CreateDriverBloc>().add(
                                                CreateDriverSubmitted(
                                                  fullName: _nameController.text
                                                      .trim(),
                                                  address: _addressController
                                                      .text
                                                      .trim(),
                                                  licenseType:
                                                      _selectedLicenseType,
                                                  licenseExpiry:
                                                      _licenseExpiry!,
                                                  profilePhoto:
                                                      _profileImagePath != null
                                                          ? File(
                                                              _profileImagePath!)
                                                          : null,
                                                  licensePhoto:
                                                      _licenseImagePath != null
                                                          ? File(
                                                              _licenseImagePath!)
                                                          : null,
                                                ),
                                              );
                                        },
                                      ),
                                    );
                                  }
                                },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
