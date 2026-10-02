import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

import '../utils/assignment_display.dart';

/// "ID: DV-0081 • [SIM B2 Umum]", turun baris otomatis di layar sempit.
class DriverMetaRow extends StatelessWidget {
  final Driver driver;

  const DriverMetaRow({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final sim = simLabel(driver.licenseType);

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'ID: ${driverCode(driver.driverId)}',
          style: const TextStyle(fontSize: 13, color: AppColors.grey500),
        ),
        if (sim.isNotEmpty) ...[
          const Text('•', style: TextStyle(color: AppColors.grey400)),
          _SimChip(label: sim),
        ],
      ],
    );
  }
}

class _SimChip extends StatelessWidget {
  final String label;

  const _SimChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.grey600,
        ),
      ),
    );
  }
}
