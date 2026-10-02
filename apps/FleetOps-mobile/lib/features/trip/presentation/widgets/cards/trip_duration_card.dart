import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

class TripDurationCard extends StatelessWidget {
  final Duration duration;
  final DateTime startTime;
  const TripDurationCard({
    super.key,
    required this.duration,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    final now = startTime;
    return CustomCard(
      backgroundColor: AppColors.primary,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Durasi Perjalanan',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey300,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            duration.toString().split('.')[0],
            style: TextStyle(
              fontSize: 32,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Mulai ${now.hour}:${now.minute}, ${now.day}-${now.month}-${now.year}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey300,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
