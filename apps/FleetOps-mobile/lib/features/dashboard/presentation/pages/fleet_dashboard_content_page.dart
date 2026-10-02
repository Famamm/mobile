import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../blocs/fleet_dashboard_bloc.dart';
import '../blocs/fleet_dashboard_event.dart';
import '../blocs/fleet_dashboard_state.dart';

class FleetDashboardContentPage extends StatefulWidget {
  const FleetDashboardContentPage({super.key});

  @override
  State<FleetDashboardContentPage> createState() =>
      _FleetDashboardContentPageState();
}

class _FleetDashboardContentPageState extends State<FleetDashboardContentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FleetDashboardBloc>()..add(LoadFleetDashboardEvent()),
      child: Scaffold(
        body: BlocBuilder<FleetDashboardBloc, FleetDashboardState>(
          builder: (context, state) {
            if (state is FleetDashboardLoadingState ||
                state is FleetDashboardInitialState) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is FleetDashboardErrorState) {
              return Center(child: Text(state.message));
            }
            if (state is FleetDashboardLoadedState) {
              final d = state.dashboard;
              return CustomRefreshIndicator(
                onRefresh: () async {
                  final bloc = context.read<FleetDashboardBloc>();
                  bloc.add(LoadFleetDashboardEvent());
                  await bloc.stream.firstWhere(
                    (s) => s is! FleetDashboardLoadingState,
                  );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _StatCard(
                        label: 'Total Kendaraan',
                        value: '${d.totalVehicles}',
                        unit: 'Kendaraan',
                        icon: Icons.directions_car_outlined,
                      ),
                      const SizedBox(height: 12),
                      _StatCard(
                        label: 'Kendaraan Aktif',
                        value: '${d.activeVehicles}',
                        unit: 'Kendaraan',
                        icon: Icons.check_circle_outline,
                      ),
                      const SizedBox(height: 12),
                      _StatCard(
                        label: 'Kendaraan Belum Ada Driver',
                        value: '${d.unsignedVehicles}',
                        unit: 'Kendaraan',
                        icon: Icons.car_rental_outlined,
                      ),
                      const SizedBox(height: 12),
                      _StatCard(
                        label: 'Total Driver',
                        value: '${d.totalDrivers}',
                        unit: 'Driver',
                        icon: Icons.people_outline,
                      ),
                      const SizedBox(height: 12),
                      _StatCard(
                        label: 'Driver Belum Ditugaskan',
                        value: '${d.unsignedDrivers}',
                        unit: 'Driver',
                        icon: Icons.person_off_outlined,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              Icon(icon, size: 18, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: unit, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
