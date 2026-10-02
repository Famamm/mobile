import 'package:flutter/material.dart';
import 'package:core/core.dart';

class InspectionLoadingDialog extends StatelessWidget {
  const InspectionLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
