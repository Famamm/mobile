import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import '../../../navigation/presentation/widgets/fleet_bottom_nav_bar.dart';
import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../../navigation/presentation/blocs/bottom_nav_state.dart';
import '../../../statistic/presentation/pages/statistic_page.dart';
import '../../../vehicle_assignment/presentation/pages/fleet_vehicle_page.dart';
import 'fleet_dashboard_content_page.dart';

class FleetDashboardPage extends StatefulWidget {
  const FleetDashboardPage({super.key});

  static const String routeName = '/fleet-dashboard';

  @override
  State<FleetDashboardPage> createState() => _FleetDashboardPageState();
}

class _FleetDashboardPageState extends State<FleetDashboardPage> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const FleetDashboardContentPage(),
      const FleetVehiclePage(),
      const StatisticPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            appBar: FleetAppBar(title: 'FleetOps', showNotificationIcon: true),
            body: IndexedStack(index: state.index, children: _pages),
            bottomNavigationBar: const FleetBottomNavBar(),
          );
        },
      ),
    );
  }
}
