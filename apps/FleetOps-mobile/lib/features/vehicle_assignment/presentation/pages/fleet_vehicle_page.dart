import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';

import '../blocs/vehicle_assignment_bloc.dart';
import '../blocs/vehicle_assignment_event.dart';
import '../blocs/vehicle_assignment_state.dart';
import '../utils/assignment_display.dart';
import '../widgets/vehicle_list_card.dart';
import 'vehicle_detail_page.dart';

class FleetVehiclePage extends StatefulWidget {
  const FleetVehiclePage({super.key});

  @override
  State<FleetVehiclePage> createState() => _FleetVehiclePageState();
}

class _FleetVehiclePageState extends State<FleetVehiclePage> {
  late final VehicleAssignmentBloc _bloc;
  String _selectedFilter = 'Truk';

  static const _filters = ['Truk', 'Mobil', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<VehicleAssignmentBloc>()
      ..add(LoadVehicleAssignmentEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  List<Vehicle> _filterVehicles(List<Vehicle> vehicles) {
    if (_selectedFilter == 'Truk') {
      return vehicles
          .where((v) => v.tipe.toLowerCase().contains('truk'))
          .toList();
    }
    if (_selectedFilter == 'Mobil') {
      return vehicles
          .where((v) => v.tipe.toLowerCase().contains('mobil'))
          .toList();
    }
    return vehicles
        .where(
          (v) =>
              !v.tipe.toLowerCase().contains('truk') &&
              !v.tipe.toLowerCase().contains('mobil'),
        )
        .toList();
  }

  Future<void> _openDetail(Vehicle vehicle) async {
    _bloc.add(LoadCurrentDriverEvent(vehicleId: vehicle.vehicleId));
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleDetailPage(vehicle: vehicle, bloc: _bloc),
      ),
    );
    if (mounted) {
      _bloc.add(LoadVehicleAssignmentEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<VehicleAssignmentBloc, VehicleAssignmentState>(
          builder: (context, state) {
            if (state is VehicleAssignmentLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is VehicleAssignmentError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => _bloc.add(LoadVehicleAssignmentEvent()),
              );
            }

            final vehicles = state is VehicleAssignmentLoaded
                ? state.vehicles
                : <Vehicle>[];
            final totalVehicles = vehicles.length;
            final activeVehicles = vehicles
                .where((vehicle) => vehicle.status.toLowerCase() == 'active')
                .length;
            final filteredVehicles = _filterVehicles(vehicles);

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _SummaryCard(
                                    label: 'Total Kendaraan',
                                    value: totalVehicles,
                                    icon: Icons.check_circle_outline_rounded,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SummaryCard(
                                    label: 'Aktif',
                                    value: activeVehicles,
                                    icon: Icons.route_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              for (final filter in _filters) ...[
                                if (filter != _filters.first)
                                  const SizedBox(width: 10),
                                Expanded(
                                  child: _FilterChip(
                                    label: filter,
                                    selected: _selectedFilter == filter,
                                    onTap: () => setState(
                                      () => _selectedFilter = filter,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _selectedFilter,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  if (filteredVehicles.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyVehicles(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      sliver: SliverList.separated(
                        itemCount: filteredVehicles.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final vehicle = filteredVehicles[index];
                          return VehicleListCard(
                            vehicle: vehicle,
                            onDetailTap: () => _openDetail(vehicle),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: assignmentCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mengecil (bukan patah di tengah kata) di layar sempit.
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 20, color: AppColors.grey700),
            ],
          ),
          const Spacer(),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 30,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Kendaraan',
                  style: TextStyle(fontSize: 14, color: AppColors.grey500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.grey300,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyVehicles extends StatelessWidget {
  const _EmptyVehicles();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 40,
            color: AppColors.grey300,
          ),
          SizedBox(height: 12),
          Text(
            'Tidak ada kendaraan untuk kategori ini',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
