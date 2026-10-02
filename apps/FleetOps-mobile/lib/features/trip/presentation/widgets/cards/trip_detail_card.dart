import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

class TripDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const TripDetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: BorderRadius.circular(16),
      alignment: Alignment.center,
      width: (MediaQuery.of(context).size.width - 48) / 2,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.primary),
            Gap(4.0),
            Text(
              label,
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(4.0),
            Text(
              value,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
