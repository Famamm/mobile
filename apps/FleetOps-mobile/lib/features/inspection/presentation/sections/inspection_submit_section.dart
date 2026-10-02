import 'package:flutter/material.dart';
import 'package:core/core.dart';

class InspectionSubmitSection extends StatelessWidget {
  final int totalItems;
  final int completedItems;
  final VoidCallback? onSubmit;
  final bool isSubmitted;

  const InspectionSubmitSection({
    super.key,
    required this.totalItems,
    required this.completedItems,
    this.onSubmit,
    this.isSubmitted = false,
  });

  bool get _canSubmit =>
      !isSubmitted && completedItems >= totalItems && totalItems > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(top: BorderSide(color: AppColors.grey300, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_canSubmit && !isSubmitted) _buildProgressHint(),
          if (!_canSubmit && !isSubmitted) const SizedBox(height: 10),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildProgressHint() {
    final remaining = totalItems - completedItems;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 13,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 5),
        Text(
          '$remaining item lagi perlu diselesaikan',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _canSubmit ? onSubmit : null,
        icon: Icon(
          isSubmitted
              ? Icons.check_circle_rounded
              : Icons.check_circle_outline_rounded,
          size: 20,
        ),
        label: Text(
          isSubmitted ? 'Inspeksi Terkirim' : 'Selesaikan Inspeksi',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grey200,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
