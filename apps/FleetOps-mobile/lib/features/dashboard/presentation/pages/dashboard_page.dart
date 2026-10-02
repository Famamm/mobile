import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../main.dart';
import '../../../../injection_container.dart';
import '../widgets/dashboard_skeleton.dart';
import '../widgets/inspection_status_card.dart';
import '../widgets/vehicle_warning_card.dart';
import '../blocs/dashboard_bloc.dart';
import '../blocs/dashboard_event.dart';
import '../blocs/dashboard_state.dart';
import '../widgets/greeting_section.dart';
import '../widgets/stats_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  bool _subscribed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route != null && !_subscribed) {
        routeObserver.subscribe(this, route);
        _subscribed = true;
      }
    });
    final driverId = sl<TokenService>().getDriverId() ?? 0;
    context.read<DashboardBloc>().add(LoadDashboardEvent(driverId: driverId));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    final driverId = sl<TokenService>().getDriverId() ?? 0;
    context.read<DashboardBloc>().add(LoadDashboardEvent(driverId: driverId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'FleetOps'),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return Skeletonizer(
              enabled: true,
              child: const DashboardSkeleton(),
            );
          }

          if (state is DashboardError) {
            final driverId = sl<TokenService>().getDriverId() ?? 0;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => context.read<DashboardBloc>().add(
                          LoadDashboardEvent(driverId: driverId),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            final e = state.entity;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Selamat datang, [Nama Driver]!
                    const SizedBox(height: 8),
                    GreetingSection(
                      driverName: e.driverName,
                      vehicleStatus: e.vehicleStatus,
                    ),
                    if (sl<TokenService>().getActiveVehicleId() == null) ...[
                      const SizedBox(height: 16),
                      VehicleWarningCard(platNomor: e.platNomor),
                    ],

                    // Section Total Jarak & Trips Selesai
                    const SizedBox(height: 20),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: StatsCard(
                              label: 'Total Jarak',
                              value: e.totalJarak.toString(),
                              subtitle: 'km',
                              icon: Icons.route,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatsCard(
                              label: 'Trips Selesai',
                              value: e.tripSelesai.toString(),
                              subtitle: 'Selesai',
                              icon: Icons.check_circle_outline,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Section Status Kendaraan
                    const SizedBox(height: 16),
                    VehicleStatusCard(),
                    const SizedBox(height: 16),
                    // Section Status Inspeksi
                    Text(
                      'Status Inspeksi Harian',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InspectionStatusCard(),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
