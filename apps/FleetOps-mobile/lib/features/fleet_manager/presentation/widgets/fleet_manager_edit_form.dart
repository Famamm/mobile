import 'dart:io';

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

class FleetManagerEditData {
  final String fullName;
  final String address;
  final String phoneNumber;
  final File? profilePhoto;

  const FleetManagerEditData({
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    this.profilePhoto,
  });
}

class FleetManagerEditForm extends StatefulWidget {
  final String submitLabel;
  final bool isLoading;
  final void Function(FleetManagerEditData) onSubmit;

  final String initialFullName;
  final String initialAddress;
  final String initialPhoneNumber;
  final String? initialPhotoUrl;

  const FleetManagerEditForm({
    super.key,
    required this.submitLabel,
    required this.isLoading,
    required this.onSubmit,
    required this.initialFullName,
    required this.initialAddress,
    required this.initialPhoneNumber,
    this.initialPhotoUrl,
  });

  @override
  State<FleetManagerEditForm> createState() => _FleetManagerEditFormState();
}

class _FleetManagerEditFormState extends State<FleetManagerEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  String? _pickedProfilePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFullName);
    _addressController = TextEditingController(text: widget.initialAddress);
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
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

  void _cancelPickedImage() {
    setState(() => _pickedProfilePath = null);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      FleetManagerEditData(
        fullName: _nameController.text.trim(),
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        profilePhoto: ImagePickerUtil.toFile(_pickedProfilePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubah Data Manajer Armada',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Perbarui data manajer armada di bawah ini',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

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

                  titleLabel('Foto Pengguna', required: false),
                  const SizedBox(height: 8),
                  _buildPhotoArea(),
                  const SizedBox(height: 12),

                  titleLabel('Nama Lengkap', required: true),
                  CustomTextField(
                    hintText: 'Masukkan nama lengkap',
                    controller: _nameController,
                    borderRadius: 8,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),

                  titleLabel('Alamat', required: true),
                  CustomTextField(
                    hintText: 'Desa, Kecamatan, Kabupaten/Kota',
                    controller: _addressController,
                    borderRadius: 8,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                  ),

                  const SizedBox(height: 12),
                  titleLabel('Nomor Telepon', required: true),
                  CustomTextField(
                    hintText: 'Masukkan nomor telepon',
                    controller: _phoneController,
                    borderRadius: 8,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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

  Widget _buildPhotoArea() {
    if (_pickedProfilePath != null) {
      return ImagePickerWidget(
        imagePath: _pickedProfilePath,
        onPickImage: _pickProfileImage,
        onRemoveImage: _cancelPickedImage,
      );
    }

    if (widget.initialPhotoUrl != null &&
        widget.initialPhotoUrl!.isNotEmpty) {
      return _ExistingPhotoPreview(
        imageUrl: widget.initialPhotoUrl!,
        onReplace: _pickProfileImage,
      );
    }

    return ImagePickerWidget(
      imagePath: null,
      onPickImage: _pickProfileImage,
      onRemoveImage: _cancelPickedImage,
    );
  }
}

class _ExistingPhotoPreview extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onReplace;

  const _ExistingPhotoPreview({
    required this.imageUrl,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 48,
                  color: AppColors.grey400,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Foto saat ini. Pilih foto baru untuk mengganti.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Pilih Foto Baru',
            textColor: AppColors.primary,
            color: AppColors.white,
            borderColor: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            onPressed: onReplace,
          ),
        ),
      ],
    );
  }
}