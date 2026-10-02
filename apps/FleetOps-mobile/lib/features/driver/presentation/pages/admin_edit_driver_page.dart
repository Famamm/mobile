import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';

import '../../domain/entities/driver.dart';

import '../blocs/reset_driver_password_bloc.dart';
import '../blocs/update_driver_bloc.dart';
import '../blocs/update_driver_event.dart';
import '../blocs/update_driver_state.dart';

class AdminEditDriverPage extends StatefulWidget {
  final Driver driver;
  const AdminEditDriverPage({super.key, required this.driver});

  @override
  State<AdminEditDriverPage> createState() => _AdminEditDriverPageState();
}

class _AdminEditDriverPageState extends State<AdminEditDriverPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late String _selectedRole;
  late String _selectedLicenseType;
  late DateTime? _licenseExpiry;
  String? _newProfileImagePath;
  String? _newLicenseImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.driver.name);
    _addressController = TextEditingController(text: widget.driver.address);
    _selectedRole = widget.driver.role;
    _selectedLicenseType = _normalizeLicenseType(widget.driver.licenseType);
    _licenseExpiry = _parseStringToDateTime(widget.driver.licenseExpiry);
  }

  String _normalizeLicenseType(String type) {
    const valid = ['SIM A', 'SIM B1 Umum', 'SIM B2 Umum', 'SIM C', 'SIM D'];
    return valid.contains(type) ? type : 'SIM A';
  }

  DateTime? _parseStringToDateTime(String dateString) {
    try {
      // Coba format "12 Juni 2030"
      final bulan = {
        'Januari': 1,
        'Februari': 2,
        'Maret': 3,
        'April': 4,
        'Mei': 5,
        'Juni': 6,
        'Juli': 7,
        'Agustus': 8,
        'September': 9,
        'Oktober': 10,
        'November': 11,
        'Desember': 12
      };

      final parts = dateString.split(' ');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          bulan[parts[1]] ?? 1,
          int.parse(parts[0]),
        );
      }
      // Coba format lain
      return DateTime.tryParse(dateString);
    } catch (_) {
      return null;
    }
  }

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
          _newProfileImagePath = path;
        } else {
          _newLicenseImagePath = path;
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: DateTime(2040),
    );
    if (picked != null && mounted) {
      setState(() {
        _licenseExpiry = picked;
      });
    }
  }

  String _formatDateDisplay(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }

  Widget _buildPhotoSection({
    required String? existingUrl,
    required String? newPath,
    required bool isProfile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foto Saat Ini',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: existingUrl != null && existingUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        existingUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_outlined, color: Colors.grey)),
            ),
          ],
        ),
        SizedBox(height: 4),
        ImagePickerWidget(
          height: 70,
          innerTitle: 'Pilih Foto Baru',
          imagePath: newPath,
          onPickImage: () => _pickImage(isProfile),
          onRemoveImage: () => setState(() {
            if (isProfile) {
              _newProfileImagePath = null;
            } else {
              _newLicenseImagePath = null;
            }
          }),
        ),
      ],
    );
  }

  void _handleSave(BuildContext blocContext) {
    print('=== HANDLE SAVE CALLED ===');

    if (_nameController.text.trim().isEmpty) {
      SnackBarUtil.showError(blocContext, 'Nama lengkap wajib diisi');
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      SnackBarUtil.showError(blocContext, 'Alamat wajib diisi');
      return;
    }

    final updated = Driver(
      driverId: widget.driver.driverId,
      name: _nameController.text.trim(),
      phone: widget.driver.phone,
      address: _addressController.text.trim(),
      role: _selectedRole,
      status: widget.driver.status,
      joinDate: widget.driver.joinDate,
      licenseType: _selectedLicenseType,
      licenseExpiry: _formatDateDisplay(_licenseExpiry),
      licenseImageUrl: widget.driver.licenseImageUrl,
      profileImageUrl: widget.driver.profileImageUrl,
      vehicleAssigned: widget.driver.vehicleAssigned,
      totalTrips: widget.driver.totalTrips,
      rating: widget.driver.rating,
    );

    if (mounted) {
      showDialog(
        context: blocContext,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return ConfirmationDialog(
            iconData: Icons.person_outline,
            iconColor: AppColors.primary,
            iconBgColor: const Color(0xFFEEF2FF),
            title: 'Ubah Data Pengemudi',
            message: 'Apakah Anda yakin ingin mengubah data pengemudi ini?',
            confirmText: 'Ya, Ubah Data',
            onConfirm: () {
              blocContext.read<UpdateDriverBloc>().add(
                    UpdateDriverSubmitted(
                      driver: updated,
                      profilePhoto: _newProfileImagePath != null
                          ? File(_newProfileImagePath!)
                          : null,
                      licensePhoto: _newLicenseImagePath != null
                          ? File(_newLicenseImagePath!)
                          : null,
                    ),
                  );
              // Remove this line: Navigator.pop(blocContext);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<UpdateDriverBloc>()),
        BlocProvider(create: (_) => sl<ResetDriverPasswordBloc>()),
      ],
      child: Builder(builder: (context) {
        final blocContext = context;
        return MultiBlocListener(
          listeners: [
            BlocListener<UpdateDriverBloc, UpdateDriverState>(
              listener: (context, state) {
                if (state is UpdateDriverSuccess) {
                  if (mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) => SuccessDialog(
                        title: 'Data Diperbarui',
                        message: 'Data pengemudi berhasil diperbarui.',
                        onOk: () {
                          if (mounted) {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pop(true);
                          }
                        },
                      ),
                    );
                  }
                } else if (state is UpdateDriverError) {
                  if (mounted) {
                    SnackBarUtil.showError(context, state.message);
                  }
                }
              },
            ),
            BlocListener<ResetDriverPasswordBloc, ResetDriverPasswordState>(
              listener: (context, state) {
                if (state is ResetDriverPasswordSuccess) {
                  if (mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => DriverCredentialsDialog(
                        title: 'Password Direset!',
                        subtitle: 'Kredensial baru pengemudi telah diperbarui',
                        username: state.username,
                        password: state.password,
                        onOk: () {},
                      ),
                    );
                  }
                } else if (state is ResetDriverPasswordError) {
                  if (mounted) {
                    SnackBarUtil.showError(context, state.message);
                  }
                }
              },
            ),
          ],
          child: Scaffold(
            appBar: CustomSimpleAppBar(title: 'Edit Pengguna'),
            backgroundColor: AppColors.backgroundLight,
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCardForm(
                      title: 'Perbarui Data Pengguna',
                      formFields: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            const SizedBox(height: 8),
                            titleLabel('Foto Profil', required: true),
                            _buildPhotoSection(
                              existingUrl: widget.driver.profileImageUrl,
                              newPath: _newProfileImagePath,
                              isProfile: true,
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
                              hintText: 'Masukkan alamat lengkap',
                              controller: _addressController,
                              borderRadius: 8,
                              validator: (v) =>
                                  v?.isEmpty == true ? 'Wajib diisi' : null,
                            ),
                            const SizedBox(height: 8),
                            
                            // titleLabel('Role', required: true),
                            // CustomDropdown(
                            //   labelText: 'Role',
                            //   value: _selectedRole,
                            //   items: const ['Driver'],
                            //   onChanged: (v) {
                            //     if (mounted) {
                            //       setState(() => _selectedRole = v ?? 'Driver');
                            //     }
                            //   },
                            //   borderRadius: 8,
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomCardForm(
                      title: 'Informasi SIM',
                      formFields: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleLabel('Jenis SIM', required: true),
                            CustomDropdown(
                              value: _selectedLicenseType,
                              items: const [
                                'SIM A',
                                'SIM B1 Umum',
                                'SIM B2 Umum',
                                'SIM C',
                                'SIM D'
                              ],
                              onChanged: (v) {
                                if (mounted) {
                                  setState(() =>
                                      _selectedLicenseType = v ?? 'SIM A');
                                }
                              },
                              borderRadius: 8,
                            ),
                            const SizedBox(height: 8),
                            titleLabel('Masa Berlaku SIM', required: true),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDateDisplay(_licenseExpiry),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            titleLabel('Foto SIM', required: true),
                            _buildPhotoSection(
                              existingUrl: widget.driver.licenseImageUrl,
                              newPath: _newLicenseImagePath,
                              isProfile: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<UpdateDriverBloc, UpdateDriverState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'Simpan Perubahan',
                            onPressed: state is UpdateDriverLoading
                                ? null
                                : () => _handleSave(blocContext),
                            color: AppColors.primary,
                            textColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<ResetDriverPasswordBloc,
                          ResetDriverPasswordState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'Reset Password',
                            color: Colors.transparent,
                            textColor: AppColors.primary,
                            borderColor: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            onPressed: state is ResetDriverPasswordLoading
                                ? null
                                : () {
                                    if (mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => ConfirmationDialog(
                                          iconData: Icons.lock_reset_outlined,
                                          iconColor: AppColors.primary,
                                          iconBgColor: const Color(0xFFEEF2FF),
                                          title: 'Reset Password',
                                          message:
                                              'Password pengemudi akan direset dan username serta password baru akan ditampilkan.',
                                          confirmText: 'Ya, Reset Password',
                                          onConfirm: () {
                                            if (mounted) {
                                              context
                                                  .read<
                                                      ResetDriverPasswordBloc>()
                                                  .reset(
                                                      widget.driver.driverId);
                                            }
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
        );
      }),
    );
  }
}
