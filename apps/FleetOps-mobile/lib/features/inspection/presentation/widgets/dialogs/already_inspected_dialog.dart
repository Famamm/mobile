import 'package:flutter/material.dart';
import 'package:core/core.dart';

class AlreadyInspectedDialog extends StatelessWidget {
  final VoidCallback onUpdatePressed;
  final VoidCallback onContinuePressed;

  const AlreadyInspectedDialog({
    required this.onUpdatePressed,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF2E7D32),
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Inspeksi Sudah Selesai',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Kamu sudah melakukan inspeksi harian hari ini. Kamu masih bisa memperbarui inspeksi atau langsung lanjut keberangkatan.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Tombol Update Inspeksi
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onUpdatePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update Inspeksi',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Tombol Lanjut Keberangkatan
            SizedBox(
              width: double.infinity,
              height: 46,
              child: TextButton(
                onPressed: onContinuePressed,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
                child: const Text(
                  'Lanjut Keberangkatan',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
