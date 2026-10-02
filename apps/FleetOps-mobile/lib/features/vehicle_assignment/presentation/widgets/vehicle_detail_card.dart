import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

import '../utils/assignment_display.dart';

class VehicleDetailCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -24,
            child: Icon(
              vehicleTypeIcon(vehicle.tipe),
              size: 150,
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATUS KENDARAAN',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  vehicle.vehicleName.isNotEmpty ? vehicle.vehicleName : '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 26,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (vehicle.tipe.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    vehicle.tipe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 15,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                _PlateStatusChip(
                  plate: vehicle.platNomor,
                  status: vehicle.status,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlateStatusChip extends StatelessWidget {
  final String plate;
  final String status;

  const _PlateStatusChip({required this.plate, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: vehicleStatusColor(status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '$plate · ${vehicleStatusLabel(status)}',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
