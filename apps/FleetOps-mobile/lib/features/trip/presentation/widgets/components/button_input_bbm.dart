import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:core/core.dart';

import '../../../../../injection_container.dart';
import '../../../../fuel/presentation/bloc/fuel_bloc.dart';
import '../../../../fuel/presentation/pages/create_fuel_page.dart';

class ButtonInputBbm extends StatelessWidget {
  final String? tripId;
  final int? currentOdometer;

  const ButtonInputBbm({this.tripId, this.currentOdometer, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final tokenService = sl<TokenService>();
        final vehicleId = tokenService.getActiveVehicleId();
        final vehicleName = tokenService.getActiveVehicleName() ?? '';
        final tipeBensin = tokenService.getActiveVehicleTipeBensin() ?? '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<FuelBloc>(),
              child: CreateFuelPage(
                vehicleId: vehicleId?.toString() ?? '0',
                currentOdometer: currentOdometer,
                vehicleName: vehicleName,
                tipeBensin: tipeBensin,
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
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_gas_station,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const Gap(12.0),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input BBM',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Catat pengisian bahan bakar kendaraan',
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
