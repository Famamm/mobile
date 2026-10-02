import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

import '../utils/assignment_display.dart';
import 'driver_avatar.dart';
import 'driver_meta_row.dart';

class DriverSelectionCard extends StatelessWidget {
  final Driver driver;
  final bool isSelected;
  final VoidCallback? onTap;

  const DriverSelectionCard({
    super.key,
    required this.driver,
    required this.isSelected,
    required this.onTap,
  });

  static const _radius = BorderRadius.all(Radius.circular(18));

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: _radius,
          // Lebar border tetap agar isi kartu tidak bergeser saat dipilih.
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : assignmentCardShadow,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: _radius,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  DriverAvatar(name: driver.name),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverDisplayName(driver),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DriverMetaRow(driver: driver),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedOpacity(
                    opacity: isSelected ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(
                      Icons.check_box_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
