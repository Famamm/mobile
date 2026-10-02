import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import 'package:fleetops_mobile/features/inspection/presentation/widgets/utils/inspection_constans.dart';
import 'package:fleetops_mobile/features/navigation/presentation/blocs/bottom_nav_cubit.dart';
import 'package:fleetops_mobile/features/navigation/presentation/blocs/bottom_nav_state.dart';
import 'package:fleetops_mobile/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fleetops_mobile/features/profile/presentation/blocs/profile_event.dart';
import 'package:fleetops_mobile/features/profile/presentation/pages/driver/driver_profile_page.dart';
import 'package:fleetops_mobile/injection_container.dart';

class NoVehicleSelectedScreen extends StatelessWidget {
  final int driverId;
  final VoidCallback onReturnFromProfile;

  const NoVehicleSelectedScreen({
    super.key,
    required this.driverId,
    required this.onReturnFromProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomNavCubit, BottomNavState>(
      listener: (context, state) {
        // Trigger rebuild saat user kembali ke tab inspeksi (untuk cek ulang vehicleId)
        if (state.index == 2) {
          onReturnFromProfile();
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'FleetOps'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  width: InspectionDimens.iconContainerSize,
                  height: InspectionDimens.iconContainerSize,
                  decoration: const BoxDecoration(
                    color: Color(InspectionColors.noVehicleIconBgColor),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_car_outlined,
                    color: Color(InspectionColors.noVehicleIconColor),
                    size: InspectionDimens.smallIconSize,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  InspectionStrings.noVehicleSelectedTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Description
                const Text(
                  InspectionStrings.selectVehicleFirstDesc,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Button
                SizedBox(
                  width: double.infinity,
                  height: InspectionDimens.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                sl<ProfileBloc>()..add(LoadProfileEvent()),
                            child: const DriverProfilePage(),
                          ),
                        ),
                      );
                      // Setelah kembali dari profile, refresh state untuk cek vehicleId
                      onReturnFromProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          InspectionDimens.borderRadius,
                        ),
                      ),
                    ),
                    child: const Text(
                      InspectionStrings.goToProfile,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
