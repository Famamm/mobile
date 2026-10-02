import 'package:flutter/material.dart';
import 'package:core/core.dart';

import '../../../../../features/inspection/domain/repositories/inspection_repository.dart';
import '../../../../../injection_container.dart';

class TripVehicleStatusCard extends StatelessWidget {
  const TripVehicleStatusCard({super.key});

  Future<bool> _hasInspectionToday(int driverId, int vehicleId) async {
    try {
      final repo = sl<InspectionRepository>();
      final inspections = await repo.getInspectionsByDriver(driverId);
      final today = DateTime.now();
      return inspections.any((i) {
        if (i.vehicleId != vehicleId) return false;
        final d = (i.createdAt ?? i.inspectionDate).toLocal();
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      });
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokenService = sl<TokenService>();
    final vehicleName = tokenService.getActiveVehicleName();
    final vehiclePlat = tokenService.getActiveVehiclePlat();
    final vehicleId = tokenService.getActiveVehicleId();
    final driverId = tokenService.getDriverId();

    if (vehicleName == null || vehiclePlat == null || vehicleId == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Text(
          'Belum ada kendaraan dipilih.\nPilih kendaraan di halaman Profile.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      );
    }

    return FutureBuilder<bool>(
      future: driverId != null
          ? _hasInspectionToday(driverId, vehicleId)
          : Future.value(false),
      builder: (context, snapshot) {
        final isInspected = snapshot.data ?? false;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        return _buildCard(
          vehicleName: vehicleName,
          vehiclePlat: vehiclePlat,
          isInspected: isInspected,
          isLoading: isLoading,
        );
      },
    );
  }

  Widget _buildCard({
    required String vehicleName,
    required String vehiclePlat,
    required bool isInspected,
    required bool isLoading,
  }) {
    final bgColor = isInspected ? AppColors.primary : AppColors.error;
    final statusText = isLoading
        ? 'Memeriksa...'
        : isInspected
            ? 'Siap Berangkat'
            : 'Belum Inspeksi';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STATUS KENDARAAN',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusText,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!isInspected && !isLoading) ...[
            const SizedBox(height: 4),
            const Text(
              'Lakukan inspeksi harian terlebih dahulu',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$vehiclePlat — $vehicleName',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
