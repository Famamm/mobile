import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../../injection_container.dart';
import '../../../fuel_history/presentation/pages/tab_history_fuel.dart';
import '../../../inspection_history/presentation/pages/inspection_history_page.dart';

import '../blocs/trip_history_bloc.dart';
import '../blocs/trip_history_event.dart';
import 'tab_history_trip.dart';


class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({Key? key}) : super(key: key);

  static const String routeName = '/trip-history';

  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _visitedTabs = {0};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _visitedTabs.add(_tabController.index));
        if (_tabController.index == 0) _loadHistory();
      }
    });
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadHistory() {
    final driverId = sl<TokenService>().getDriverId() ?? 0;
    context.read<TripHistoryBloc>().add(LoadTripHistory(driverId: driverId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'FleetOps', backButton: false),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: CupertinoSlidingSegmentedControl<int>(
              backgroundColor: AppColors.grey100,
              thumbColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              children: {
                0: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Perjalanan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _tabController.index == 0
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                1: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Inspeksi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _tabController.index == 1
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                2: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Bensin',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _tabController.index == 2
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              },
              groupValue: _tabController.index,
              onValueChanged: (int? value) {
                if (value != null) {
                  setState(() {
                    _tabController.animateTo(value);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const TabHistoryTrip(),
                _visitedTabs.contains(1)
                    ? const InspectionHistoryPage()
                    : const SizedBox.shrink(),
                _visitedTabs.contains(2)
                    ? const TabHistoryFuel()
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
