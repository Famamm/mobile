import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Dialog konfirmasi hapus kendaraan.
///
/// [ConfirmationDialog] sudah menutup dirinya sendiri sebelum memanggil
/// [onConfirm] — pemanggil tidak perlu (dan tidak boleh) pop lagi.
void showDeleteVehicleDialog(
  BuildContext context, {
  required String vehicleName,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (_) => ConfirmationDialog(
      iconData: Icons.delete_outline,
      iconColor: Colors.red,
      iconBgColor: const Color(0xFFFFEEEE),
      title: 'Hapus Kendaraan',
      message: 'Apakah Anda yakin ingin menghapus kendaraan "$vehicleName"?',
      confirmText: 'Ya, Hapus',
      onConfirm: onConfirm,
    ),
  );
}
