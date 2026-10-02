import 'package:flutter/material.dart';
import 'package:core/core.dart';

class InspectionAlertCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const InspectionAlertCard({
    super.key,
    this.title = 'Inspeksi Harian Wajib',
    this.message =
        'Selesaikan inspeksi sebelum memulai trip. Tambahkan catatan untuk kondisi yang perlu di perhatikan.',
    this.icon = Icons.warning_amber_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningbg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconBox(),
          const SizedBox(width: 12),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: AppColors.warning),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.warning.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withOpacity(0.85),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
