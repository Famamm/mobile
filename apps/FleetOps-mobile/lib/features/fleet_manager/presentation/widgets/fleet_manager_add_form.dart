import 'dart:io';

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

class FleetManagerFormData {
  final String fullName;
  final String address;
  final String phoneNumber;
  final File? profilePhoto;

  const FleetManagerFormData({
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    this.profilePhoto,
  });
}

class FleetManagerForm extends StatefulWidget {
  final String submitLabel;
  final bool isLoading;
  final void Function(FleetManagerFormData) onSubmit;
  final String? initialFullName;
  final String? initialAddress;
  final String? initialPhoneNumber;
  final String? initialPhotoUrl;

  const FleetManagerForm({
    super.key,
    required this.submitLabel,
    required this.isLoading,
    required this.onSubmit,
    this.initialFullName,
    this.initialAddress,
    this.initialPhoneNumber,
    this.initialPhotoUrl,
  });

  @override
  State<FleetManagerForm> createState() => _FleetManagerFormState();
}

class _FleetManagerFormState extends State<FleetManagerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;

  /// Path lokal hasil picker (null = belum pilih foto baru).
  String? _pickedProfilePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFullName ?? '');
    _addressController = TextEditingController(
      text: widget.initialAddress ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.initialPhoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    if (!mounted) return;
    final path = await ImagePickerUtil.pick(context);
    if (path != null && mounted) {
      setState(() => _pickedProfilePath = path);
    }
  }

  void _removeProfileImage() {
    setState(() => _pickedProfilePath = null);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      FleetManagerFormData(
        fullName: _nameController.text.trim(),
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        profilePhoto: _pickedProfilePath != null
            ? File(_pickedProfilePath!)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _pickedProfilePath;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input Data Manajer Armada',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Lengkapi formulir di bawah ini untuk menyimpan data manajer armada',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // ── Card Informasi Pengguna ──
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
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  titleLabel('Unggah Foto Pengguna', required: false),
                  if (_pickedProfilePath == null &&
                      widget.initialPhotoUrl != null &&
                      widget.initialPhotoUrl!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            widget.initialPhotoUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              size: 48,
                              color: AppColors.grey400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Foto saat ini. Pilih foto baru untuk mengganti.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  ImagePickerWidget(
                    imagePath: imagePath,
                    onPickImage: _pickProfileImage,
                    onRemoveImage: _removeProfileImage,
                  ),
                  const SizedBox(height: 8),

                  titleLabel('Nama Lengkap', required: true),
                  CustomTextField(
                    hintText: 'Masukkan nama lengkap',
                    controller: _nameController,
                    borderRadius: 8,
                    validator: (v) => v?.isEmpty == true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 8),

                  titleLabel('Alamat', required: true),
                  CustomTextField(
                    hintText: 'Desa, Kecamatan, Kabupaten/Kota',
                    controller: _addressController,
                    borderRadius: 8,
                    validator: (v) => v?.isEmpty == true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 8),
                  titleLabel('Nomor Telepon', required: true),
                  CustomTextField(
                    hintText: 'Masukkan nomor telepon',
                    controller: _phoneController,
                    borderRadius: 8,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.isEmpty == true ? 'Wajib diisi' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Tombol Submit ──
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: widget.submitLabel,
                isLoading: widget.isLoading,
                onPressed: widget.isLoading ? null : _submit,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
