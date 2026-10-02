import 'package:flutter/material.dart';
import 'package:core/core.dart';

class InspectionStatusBadge extends StatelessWidget {
  final String status;
  const InspectionStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (textColor, bgColor) = switch (status.toUpperCase()) {
      'SELESAI' => (AppColors.successDark, AppColors.successLight),
      'ADA MASALAH' => (AppColors.warning, AppColors.warningLight),
      _ => (AppColors.primary, AppColors.primaryLight),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0.3),
      ),
    );
  }
}
