import 'package:fleetops_mobile/features/vehicle/presentation/pages/add_vehicle_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/injection_container.dart';

import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../../navigation/presentation/blocs/bottom_nav_state.dart';
import '../../domain/entities/vehicle.dart';
import '../blocs/admin_vehicle_list_bloc.dart';
import '../blocs/admin_vehicle_list_event.dart';
import '../blocs/admin_vehicle_list_state.dart';
import 'admin_vehicle_detail_page.dart';

class AdminVehicleListPage extends StatefulWidget {
  const AdminVehicleListPage({super.key});

  @override
  State<AdminVehicleListPage> createState() => _AdminVehicleListPageState();
}

class _AdminVehicleListPageState extends State<AdminVehicleListPage> {
  late final AdminVehicleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<AdminVehicleListBloc>()..add(LoadAdminVehicleList());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<BottomNavCubit, BottomNavState>(
        listener: (context, navState) {
          if (navState is BottomNavChanged && navState.index == 1) {
            _bloc.add(LoadAdminVehicleList());
          }
        },
        child: const _AdminVehicleListView(),
      ),
    );
  }
}

class _AdminVehicleListView extends StatefulWidget {
  const _AdminVehicleListView();

  @override
  State<_AdminVehicleListView> createState() => _AdminVehicleListViewState();
}

class _AdminVehicleListViewState extends State<_AdminVehicleListView> {
  String _selectedFilter = 'Semua';

  Future<void> _navigateToDetail(Vehicle vehicle) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminVehicleDetailPage(vehicle: vehicle),
      ),
    );
    if (deleted == true && mounted) {
      context.read<AdminVehicleListBloc>().add(LoadAdminVehicleList());
    }
  }

  List<Vehicle> _filteredVehicles(List<Vehicle> vehicles) {
    if (_selectedFilter == 'Semua') {
      return vehicles;
    } else if (_selectedFilter == 'Truk') {
      return vehicles
          .where((v) => v.tipe.toLowerCase().contains('truk'))
          .toList();
    } else if (_selectedFilter == 'Mobil') {
      return vehicles
          .where((v) => v.tipe.toLowerCase().contains('mobil'))
          .toList();
    } else {
      return vehicles
          .where(
            (v) =>
                !v.tipe.toLowerCase().contains('truk') &&
                !v.tipe.toLowerCase().contains('mobil'),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<AdminVehicleListBloc, AdminVehicleListState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              if (state is AdminVehicleListLoaded) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Statistik Kendaraan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildStatCards(state.vehicles)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Daftar Kendaraan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildFilterChips()),
                SliverToBoxAdapter(
                  child: Padding(padding: const EdgeInsetsGeometry.all(4)),
                ),
                _buildVehicleList(
                  state.vehicles,
                  context.read<AdminVehicleListBloc>(),
                ),
              ] else if (state is AdminVehicleListLoading ||
                  state is AdminVehicleDeleteSuccess) ...[
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ] else if (state is AdminVehicleListError) ...[
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<AdminVehicleListBloc>()
                              .add(LoadAdminVehicleList()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton(
          heroTag: 'fab_vehicle_list',
          backgroundColor: AppColors.primary,
          onPressed: () async {
            await Navigator.pushNamed(ctx, AddVehiclePage.routeName);
            if (ctx.mounted) {
              ctx.read<AdminVehicleListBloc>().add(LoadAdminVehicleList());
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCards(List<Vehicle> vehicles) {
    final total = vehicles.length;
    final active = vehicles.where((v) => v.status == 'Active').length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Total Kendaraan',
              value: '$total',
              unit: 'Kendaraan',
              icon: Icons.check_circle_outline,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Aktif',
              value: '$active',
              unit: 'Kendaraan',
              icon: Icons.route,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = ['Semua', 'Truk', 'Mobil', 'Lainnya'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: AnimatedContainer(
                  width: 120,
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    filter,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVehicleList(List<Vehicle> vehicles, AdminVehicleListBloc bloc) {
    final filtered = _filteredVehicles(vehicles);
    if (filtered.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.bgprimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Belum ada kendaraan',
                style: TextStyle(fontSize: 16, color: AppColors.grey400),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AddVehiclePage.routeName,
                  ).then((_) => bloc.add(LoadAdminVehicleList()));
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Tambah Kendaraan'),
              ),
            ],
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final vehicle = filtered[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                vehicle.vehicleName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(vehicle.platNomor),
              trailing: GestureDetector(
                onTap: () => _navigateToDetail(vehicle),
                child: Text(
                  'Detail',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }, childCount: filtered.length),
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
