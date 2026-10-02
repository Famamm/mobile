import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import '../../../users/presentation/pages/admin_user_list_page.dart';
import '../../../vehicle/presentation/pages/admin_vehicle_list_page.dart';
import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../../navigation/presentation/blocs/bottom_nav_state.dart';
import '../../../navigation/presentation/widgets/admin_bottom_nav_bar.dart';
import 'admin_dashboard_content_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  static const String routeName = '/admin-dashboard';

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const AdminDashboardContentPage(),
      const AdminVehicleListPage(),
      const AdminUserListPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AdminAppBar(title: 'FleetOps'),
            body: IndexedStack(index: state.index, children: _pages),
            bottomNavigationBar: const AdminBottomNavBar(),
          );
        },
      ),
    );
  }
}
