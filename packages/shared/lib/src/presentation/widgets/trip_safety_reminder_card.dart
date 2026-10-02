import 'package:core/core.dart';
import 'package:flutter/material.dart';

class TripSafetyReminderCard extends StatelessWidget {
  const TripSafetyReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsGeometry.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.warning, width: 4.0)),
        color: AppColors.warningbg,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: AppColors.warning),
          SizedBox(width: 12.0),
          Expanded(
            child: Text(
              'Pastikan semua data benar sebelum memulai perjalanan.',
              style: TextStyle(fontSize: 14, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
