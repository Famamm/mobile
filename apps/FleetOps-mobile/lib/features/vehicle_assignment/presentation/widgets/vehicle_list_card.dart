import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

import '../utils/assignment_display.dart';

class VehicleListCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onDetailTap;

  const VehicleListCard({
    super.key,
    required this.vehicle,
    required this.onDetailTap,
  });

  static const _radius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: _radius,
      child: InkWell(
        onTap: onDetailTap,
        borderRadius: _radius,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: _radius,
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            children: [
              Icon(
                vehicleTypeIcon(vehicle.tipe),
                color: AppColors.grey700,
                size: 26,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.vehicleName.isNotEmpty
                          ? vehicle.vehicleName
                          : '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicle.platNomor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Detail',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
