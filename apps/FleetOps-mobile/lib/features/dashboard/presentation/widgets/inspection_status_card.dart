import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

import '../../../../features/inspection/domain/repositories/inspection_repository.dart';
import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../../../injection_container.dart';

class InspectionStatusCard extends StatelessWidget {
  const InspectionStatusCard({super.key});

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
    final vehicleId = tokenService.getActiveVehicleId();
    final driverId = tokenService.getDriverId();

    if (vehicleId == null || driverId == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: _hasInspectionToday(driverId, vehicleId),
      builder: (context, snapshot) {
        final isInspected = snapshot.data ?? false;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        if (isLoading) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(
                color: isInspected ? AppColors.primary : AppColors.error,
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isInspected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: isInspected ? AppColors.primary : AppColors.error,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inspeksi Harian',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Periksa sebelum trip',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isInspected ? AppColors.primary : AppColors.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isInspected ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isInspected ? 'Sudah Diperiksa' : 'Perlu Diperiksa',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Button
              if (!isInspected)
                ElevatedButton(
                  onPressed: () => context.read<BottomNavCubit>().changeTab(2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Mulai',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
