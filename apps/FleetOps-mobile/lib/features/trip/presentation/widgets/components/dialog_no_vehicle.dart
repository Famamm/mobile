import 'package:flutter/material.dart';
import 'package:core/core.dart';

class DialogNoVehicle extends StatelessWidget {
  const DialogNoVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB300)),
          SizedBox(width: 8),
          Text('Kendaraan belum dipilih'),
        ],
      ),
      content: const Text(
        'Anda harus memiliki kendaraan dan memilihnya di halaman Profile sebelum memulai perjalanan.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/add-vehicle');
          },
          child: const Text('Tambah Kendaraan'),
        ),
      ],
    );
  }
}
