import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/injection_container.dart';

import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../../navigation/presentation/blocs/bottom_nav_state.dart';
import '../blocs/admin_dashboard_bloc.dart';
import '../blocs/admin_dashboard_event.dart';
import '../blocs/admin_dashboard_state.dart';
import '../../domain/entities/admin_dashboard_entity.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';
import '../widgets/admin_bbm_charts.dart';
import '../widgets/admin_fleet_activity_chart.dart';

class AdminDashboardContentPage extends StatefulWidget {
  const AdminDashboardContentPage({super.key});

  @override
  State<AdminDashboardContentPage> createState() =>
      _AdminDashboardContentPageState();
}

class _AdminDashboardContentPageState extends State<AdminDashboardContentPage> {
  late final AdminDashboardBloc _bloc;

  String _rangeArmada = 'week';
  String _rangeBbm = 'week';

  /// Ringkasan statistik all-time, tidak terpengaruh pemilihan rentang chart.
  AdminDashboard? _summary;
  bool _summaryLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSummary();
    _bloc = sl<AdminDashboardBloc>()
      ..add(LoadAdminDashboard(rangeArmada: _rangeArmada, rangeBbm: _rangeBbm));
  }

  /// Memuat ringkasan all-time tanpa parameter rentang, sehingga nilainya
  /// tetap sama walau rentang chart diganti.
  Future<void> _loadSummary() async {
    setState(() => _summaryLoading = true);
    try {
      final summary = await sl<AdminDashboardRepository>().getDashboard();
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _summaryLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _summaryLoading = false);
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _reload() {
    _bloc.add(
      LoadAdminDashboard(rangeArmada: _rangeArmada, rangeBbm: _rangeBbm),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat pagi,';
    if (hour < 15) return 'Selamat siang,';
    if (hour < 18) return 'Selamat sore,';
    return 'Selamat malam,';
  }

  @override
  Widget build(BuildContext context) {
    final userName = sl<TokenService>().getUserName() ?? 'Admin';

    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<BottomNavCubit, BottomNavState>(
        listener: (context, navState) {
          if (navState is BottomNavChanged && navState.index == 0) {
            _loadSummary();
            _reload();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
            builder: (context, state) {
              final isLoading =
                  state is AdminDashboardLoading ||
                  state is AdminDashboardInitial;
              final loaded = state is AdminDashboardLoaded ? state : null;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state is AdminDashboardError)
                      _ErrorCard(message: state.message, onRetry: _reload)
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Total Kendaraan',
                              value: _summary?.totalVehicles.toString() ?? '-',
                              unit: 'Kendaraan',
                              icon: Icons.directions_car,
                              isLoading: _summaryLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Total Pengemudi',
                              value: _summary?.totalDrivers.toString() ?? '-',
                              unit: 'Pengemudi',
                              icon: Icons.person,
                              isLoading: _summaryLoading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Total Perjalanan',
                              value: _summary?.totalTrips.toString() ?? '-',
                              unit: 'Trip',
                              icon: Icons.route,
                              isLoading: _summaryLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Total Fleet Manager',
                              value:
                                  _summary?.totalFleetManagers.toString() ??
                                  '-',
                              unit: 'Orang',
                              icon: Icons.badge,
                              isLoading: _summaryLoading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (isLoading)
                        const _ChartSkeleton()
                      else
                        AdminFleetActivityChart(
                          data: loaded?.aktivitasArmada ?? const [],
                          rincian:
                              loaded?.rincianAktivitasArmada ??
                              const AdminRincianAktivitasArmada(
                                totalJarak: 0,
                                totalDurasi: 0,
                                rataRataKecepatan: 0,
                              ),
                          range: _rangeArmada,
                          onRangeChanged: (value) {
                            setState(() => _rangeArmada = value);
                            _bloc.add(LoadArmadaChart(rangeArmada: value));
                          },
                        ),
                      const SizedBox(height: 12),
                      if (isLoading)
                        const _ChartSkeleton()
                      else
                        AdminBbmCostChart(
                          data: loaded?.aktivitasBbm ?? const [],
                          totalLiter: loaded?.totalBbmLiter ?? 0,
                          totalHarga: loaded?.totalHargaBbm ?? 0,
                          jenisCount: loaded?.rincianJenisBbm.length ?? 0,
                          range: _rangeBbm,
                          onRangeChanged: (value) {
                            setState(() => _rangeBbm = value);
                            _bloc.add(LoadBbmChart(rangeBbm: value));
                          },
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
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
  final bool isLoading;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.isLoading = false,
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
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, size: 18, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 8),
          isLoading
              ? const SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: unit,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

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
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
