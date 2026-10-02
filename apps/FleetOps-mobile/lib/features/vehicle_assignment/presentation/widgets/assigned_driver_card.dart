import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

import '../utils/assignment_display.dart';
import 'driver_avatar.dart';
import 'driver_meta_row.dart';

class AssignedDriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback onChangeDriver;

  const AssignedDriverCard({
    super.key,
    required this.driver,
    required this.onChangeDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: assignmentCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DriverAvatar(
                name: driver.name,
                size: 56,
                showActiveDot: isDriverActive(driver),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverDisplayName(driver),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    DriverMetaRow(driver: driver),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: AppColors.grey100),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: onChangeDriver,
              icon: const Icon(Icons.sync_rounded, size: 20),
              // Style di Text (bukan styleFrom.textStyle) agar font tema tetap
              // dipakai.
              label: const Text(
                'Ganti Pengemudi',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
