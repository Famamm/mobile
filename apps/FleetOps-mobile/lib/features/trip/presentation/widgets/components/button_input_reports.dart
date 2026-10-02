import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:core/core.dart';

import '../../../../../injection_container.dart';
import '../../blocs/damage_report_bloc.dart';
import '../../pages/demage_report_page.dart';

class ButtonInputReports extends StatelessWidget {
  final int tripId;
  final int driverId;
  final int vehicleId;
  final int? currentOdometer;

  const ButtonInputReports({
    super.key,
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    this.currentOdometer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<DamageReportBloc>(),
              child: DamageReportPage(
                tripId: tripId,
                driverId: driverId,
                vehicleId: vehicleId,
                currentOdometer: currentOdometer,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15), // ← merah muda
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.report_problem_outlined, // ← icon laporan
                color: AppColors.error,
                size: 22,
              ),
            ),
            const Gap(12.0),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Laporkan Kerusakan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Laporkan kerusakan kendaraan saat trip',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}