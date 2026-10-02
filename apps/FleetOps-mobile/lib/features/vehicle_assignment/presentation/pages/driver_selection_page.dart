import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:shared/shared.dart';

import '../blocs/vehicle_assignment_bloc.dart';
import '../blocs/vehicle_assignment_event.dart';
import '../blocs/vehicle_assignment_state.dart';
import '../utils/assignment_display.dart';
import '../widgets/driver_selection_card.dart';

class DriverSelectionPage extends StatefulWidget {
  final Vehicle vehicle;
  final VehicleAssignmentBloc bloc;

  const DriverSelectionPage({
    super.key,
    required this.vehicle,
    required this.bloc,
  });

  @override
  State<DriverSelectionPage> createState() => _DriverSelectionPageState();
}

class _DriverSelectionPageState extends State<DriverSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedDriverId;
  String? _simFilter;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(LoadAvailableDriversEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Driver> _driversOf(VehicleAssignmentState state) => switch (state) {
    VehicleAssignmentLoaded(:final drivers) => drivers,
    VehicleAssignmentAssigning(:final drivers) => drivers,
    _ => const <Driver>[],
  };

  List<Driver> _filterDrivers(List<Driver> drivers) {
    final query = _searchController.text.trim().toLowerCase();
    return drivers.where((driver) {
      if (_simFilter != null && simLabel(driver.licenseType) != _simFilter) {
        return false;
      }
      return query.isEmpty ||
          driverDisplayName(driver).toLowerCase().contains(query) ||
          driverCode(driver.driverId).toLowerCase().contains(query);
    }).toList();
  }

  Driver? _findDriver(List<Driver> drivers, int? driverId) {
    if (driverId == null) return null;
    for (final driver in drivers) {
      if (driver.driverId == driverId) return driver;
    }
    return null;
  }

  void _toggleDriver(Driver driver) {
    setState(() {
      _selectedDriverId = _selectedDriverId == driver.driverId
          ? null
          : driver.driverId;
    });
  }

  Future<void> _showSimFilter(List<String> options) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                'Filter SIM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                children: [
                  for (final option in ['', ...options])
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(option.isEmpty ? 'Semua SIM' : option),
                      trailing: (option.isEmpty ? null : option) == _simFilter
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                            )
                          : null,
                      onTap: () => Navigator.pop(sheetContext, option),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() => _simFilter = selected.isEmpty ? null : selected);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<VehicleAssignmentBloc, VehicleAssignmentState>(
        listener: (context, state) {
          if (state is VehicleAssignmentAssignmentSuccess) {
            SnackBarUtil.showSuccess(
              context,
              state.message,
              duration: const Duration(seconds: 2),
            );
            Navigator.pop(context);
          } else if (state is VehicleAssignmentError) {
            SnackBarUtil.showError(
              context,
              state.message,
              duration: const Duration(seconds: 4),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: CustomSimpleAppBar(
            title: 'Pilih Pengemudi',
          ),
          body: BlocBuilder<VehicleAssignmentBloc, VehicleAssignmentState>(
            builder: (context, state) {
              if (state is VehicleAssignmentLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final drivers = _driversOf(state);
              final visibleDrivers = _filterDrivers(drivers);
              final selectedDriver = _findDriver(drivers, _selectedDriverId);
              final isAssigning = state is VehicleAssignmentAssigning;
              final simOptions = {
                for (final driver in drivers) simLabel(driver.licenseType),
              }..remove('');

              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _SearchField(
                                  controller: _searchController,
                                  onChanged: () => setState(() {}),
                                ),
                                const SizedBox(height: 18),
                                _ListHeader(
                                  count: visibleDrivers.length,
                                  simFilter: _simFilter,
                                  onFilterTap:
                                      simOptions.isEmpty && _simFilter == null
                                      ? null
                                      : () => _showSimFilter(
                                          simOptions.toList()..sort(),
                                        ),
                                ),
                                const SizedBox(height: 12),
                                _VehicleBanner(vehicle: widget.vehicle),
                              ],
                            ),
                          ),
                        ),
                        if (visibleDrivers.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _EmptyDrivers(
                              isFiltered: drivers.isNotEmpty,
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            sliver: SliverList.separated(
                              itemCount: visibleDrivers.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final driver = visibleDrivers[index];
                                return DriverSelectionCard(
                                  driver: driver,
                                  isSelected:
                                      driver.driverId == _selectedDriverId,
                                  onTap: isAssigning
                                      ? null
                                      : () => _toggleDriver(driver),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  _SelectionFooter(
                    selectedName: selectedDriver == null
                        ? null
                        : driverDisplayName(selectedDriver),
                    isAssigning: isAssigning,
                    onConfirm: selectedDriver == null || isAssigning
                        ? null
                        : () => widget.bloc.add(
                            AssignVehicleDriverEvent(
                              vehicleId: widget.vehicle.vehicleId,
                              driverId: selectedDriver.driverId,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.grey200),
        boxShadow: assignmentCardShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Cari nama pengemudi...',
          hintStyle: const TextStyle(color: AppColors.grey400),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.grey400,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Hapus pencarian',
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.grey400,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged();
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  final int count;
  final String? simFilter;
  final VoidCallback? onFilterTap;

  const _ListHeader({
    required this.count,
    required this.simFilter,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFiltered = simFilter != null;

    return Row(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'PENGEMUDI TERSEDIA ($count)',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: AppColors.grey500,
              ),
            ),
          ),
        ),
        if (onFilterTap != null)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: TextButton.icon(
              onPressed: onFilterTap,
              icon: const Icon(Icons.tune_rounded, size: 16),
              label: Text(
                simFilter ?? 'Filter SIM',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                backgroundColor: isFiltered
                    ? AppColors.primaryLight
                    : Colors.transparent,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
      ],
    );
  }
}

class _VehicleBanner extends StatelessWidget {
  final Vehicle vehicle;

  const _VehicleBanner({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isActive = vehicle.status.trim().toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgprimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              vehicleTypeIcon(vehicle.tipe),
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'TUGASKAN UNTUK KENDARAAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    text: vehicle.vehicleName,
                    style: const TextStyle(color: AppColors.textPrimary),
                    children: [
                      // Spasi tak terputus: plat nomor tidak terbelah ke dua
                      // baris.
                      TextSpan(
                        text:
                            ' · '
                            '${vehicle.platNomor.replaceAll(' ', ' ')}',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : vehicleStatusColor(vehicle.status),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              vehicleStatusLabel(vehicle.status),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDrivers extends StatelessWidget {
  final bool isFiltered;

  const _EmptyDrivers({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.bgprimary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltered ? Icons.search_off_rounded : Icons.person_off_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isFiltered
                ? 'Pengemudi tidak ditemukan'
                : 'Belum ada pengemudi tersedia',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isFiltered
                ? 'Coba kata kunci atau filter SIM lain.'
                : 'Saat ini tidak ada pengemudi yang bisa ditugaskan.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _SelectionFooter extends StatelessWidget {
  final String? selectedName;
  final bool isAssigning;
  final VoidCallback? onConfirm;

  const _SelectionFooter({
    required this.selectedName,
    required this.isAssigning,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F111827),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Satu baris bila muat, turun ke baris kedua di layar sempit.
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    const Text(
                      'Pengemudi Terpilih:',
                      style: TextStyle(fontSize: 13, color: AppColors.grey500),
                    ),
                    Text(
                      selectedName ?? 'Belum dipilih',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: selectedName == null
                            ? AppColors.grey400
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.grey200,
                    disabledForegroundColor: AppColors.grey400,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: isAssigning
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: AppColors.primary,
                          ),
                        )
                      : const Text(
                          'Konfirmasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
