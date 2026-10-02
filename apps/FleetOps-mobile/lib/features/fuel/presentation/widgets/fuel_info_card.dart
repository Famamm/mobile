import 'package:flutter/material.dart';
import 'package:core/core.dart';

class FuelInfoCard extends StatelessWidget {
  final String vehicleName;

  const FuelInfoCard({
    Key? key,
    required this.vehicleName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              vehicleName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
