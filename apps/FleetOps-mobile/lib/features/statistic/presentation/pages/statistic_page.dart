import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/statistic_entity.dart';
import '../blocs/statistic_bloc.dart';
import '../blocs/statistic_event.dart';
import '../blocs/statistic_state.dart';
import '../widgets/activity_chart.dart';
import '../widgets/fleet_summary_card.dart';
import '../widgets/operational_summary.dart';
import '../widgets/period_selector.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late DateTime _selectedPeriod;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedPeriod = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StatisticBloc>()
        ..add(
          LoadStatisticEvent(
            month: _selectedPeriod.month,
            year: _selectedPeriod.year,
          ),
        ),
      child: BlocBuilder<StatisticBloc, StatisticState>(
        builder: (context, state) {
          if (state is StatisticLoading || state is StatisticInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StatisticError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<StatisticBloc>().add(
                      LoadStatisticEvent(
                        month: _selectedPeriod.month,
                        year: _selectedPeriod.year,
                      ),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          final statistic = (state as StatisticLoaded).statistic;
          return _StatisticContent(
            statistic: statistic,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() => _selectedPeriod = period);
              context.read<StatisticBloc>().add(
                LoadStatisticEvent(month: period.month, year: period.year),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatisticContent extends StatelessWidget {
  final StatisticEntity statistic;
  final DateTime selectedPeriod;
  final ValueChanged<DateTime> onPeriodChanged;

  const _StatisticContent({
    required this.statistic,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PeriodSelector(
            selectedPeriod: selectedPeriod,
            onChanged: onPeriodChanged,
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Ringkasan Armada'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.2,
            children: [
              FleetSummaryCard(
                title: 'Total Kendaraan',
                value: statistic.totalVehicles,
                subtitle: 'Kendaraan terdaftar',
              ),
              FleetSummaryCard(
                title: 'Aktif',
                value: statistic.activeVehicles,
                subtitle: 'Sedang digunakan',
              ),
              FleetSummaryCard(
                title: 'Dalam Perawatan',
                value: statistic.vehiclesInService,
                subtitle: 'Sedang diservis',
              ),
              FleetSummaryCard(
                title: 'Tidak Aktif',
                value: statistic.inactiveVehicles,
                subtitle: 'Tidak digunakan',
              ),
            ],
          ),
          const SizedBox(height: 24),
          ActivityChart(
            activity: statistic.dailyActivity,
            totalTrips: statistic.totalTrips,
          ),
          const SizedBox(height: 24),
          OperationalSummary(statistic: statistic),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
