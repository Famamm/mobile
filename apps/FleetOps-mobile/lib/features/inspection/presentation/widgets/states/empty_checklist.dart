import 'package:flutter/material.dart';
import 'package:core/core.dart';

class EmptyChecklist extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyChecklist({
    super.key,
    this.title = 'Tidak ada item inspeksi',
    this.subtitle = 'Pilih kategori untuk memulai inspeksi',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grey300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.checklist_rounded,
        size: 42,
        color: AppColors.grey300,
      ),
    );
  }
}
