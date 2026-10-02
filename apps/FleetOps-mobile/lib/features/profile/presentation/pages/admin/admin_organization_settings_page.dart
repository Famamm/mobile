import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class AdminOrganizationSettingsPage extends StatelessWidget {
  const AdminOrganizationSettingsPage({super.key});

  InputDecoration _inputDeco(String hint, {bool readOnly = false}) =>
      InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: readOnly ? Colors.grey[50] : Colors.grey[100],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: CustomSimpleAppBar(title: 'Pengaturan Organisasi'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCardForm(
              title: 'Informasi Organisasi',
              formFields: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NAMA ORGANISASI',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    TextField(
                      readOnly: true,
                      controller:
                          TextEditingController(text: 'FleetOps Organization'),
                      decoration: _inputDeco('Nama Organisasi', readOnly: true),
                    ),
                    const SizedBox(height: 16),
                    const Text('ALAMAT',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: 'Jl Keputih Sukolilo Keputih Surabaya'),
                      decoration: _inputDeco('Alamat', readOnly: true),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tombol Hapus Organisasi
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Hapus Organisasi',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showDeleteDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        iconData: Icons.delete_outline,
        iconColor: Colors.red,
        iconBgColor: const Color(0xFFFFEEEE),
        title: 'Konfirmasi Hapus',
        titleColor: Colors.red,
        message: 'Apakah Anda yakin ingin menghapus organisasi ini?',
        confirmText: 'Hapus Organisasi',
        onConfirm: () {},
      ),
    );
  }
}
