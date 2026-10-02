import 'package:flutter/material.dart';
import 'package:core/core.dart';

class InspectionEmptyState extends StatelessWidget {
  final String message;

  const InspectionEmptyState({
    super.key,
    this.message = 'Tidak ada riwayat inspeksi.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.checklist_rounded,
              size: 56,
              color: AppColors.grey300,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
