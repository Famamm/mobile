import 'package:flutter/material.dart';
import 'package:core/core.dart';

class GreetingSection extends StatelessWidget {
  final String driverName;
  final String vehicleStatus;

  const GreetingSection({
    super.key,
    required this.driverName,
    required this.vehicleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final tripStatus = vehicleStatus == 'sedang_bertugas'
        ? 'Trip Aktif'
        : 'Tidak ada trip aktif';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat pagi,',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                driverName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tripStatus,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
