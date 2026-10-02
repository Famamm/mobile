import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:shared/shared.dart';

import '../blocs/vehicle_assignment_bloc.dart';
import '../blocs/vehicle_assignment_event.dart';
import '../blocs/vehicle_assignment_state.dart';
import '../utils/assignment_display.dart';
import '../widgets/assigned_driver_card.dart';
import '../widgets/vehicle_detail_card.dart';
import 'driver_selection_page.dart';

class VehicleDetailPage extends StatelessWidget {
  final Vehicle vehicle;
  final VehicleAssignmentBloc bloc;

  const VehicleDetailPage({
    super.key,
    required this.vehicle,
    required this.bloc,
  });

  // Tidak perlu memuat ulang setelah kembali: bloc sudah menyimpan pengemudi
  // terbaru (berhasil ditugaskan) atau tetap memakai data lama (batal).
  void _openDriverSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DriverSelectionPage(vehicle: vehicle, bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: const CustomSimpleAppBar(title: 'Detail Kendaraan'),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VehicleDetailCard(vehicle: vehicle),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _InfoCard(
                          title: 'Total Jarak',
                          icon: Icons.speed_rounded,
                          label: 'ODOMETER',
                          value: formatThousands(vehicle.odometer),
                          unit: 'km',
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _InfoCard(
                          title: 'Jadwal Rutin',
                          icon: Icons.build_outlined,
                          label: 'SERVIS BERIKUTNYA',
                          value: '1.750',
                          unit: 'km lagi',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pengemudi Saat Ini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<VehicleAssignmentBloc, VehicleAssignmentState>(
                  builder: (context, state) => switch (state) {
                    VehicleAssignmentLoading() ||
                    VehicleAssignmentLoaded(
                      isCurrentDriverLoading: true,
                    ) => const _DriverLoadingCard(),
                    VehicleAssignmentLoaded(:final currentDriverError?) =>
                      _DriverErrorCard(
                        message: currentDriverError,
                        onRetry: () => bloc.add(
                          LoadCurrentDriverEvent(vehicleId: vehicle.vehicleId),
                        ),
                      ),
                    VehicleAssignmentLoaded(:final currentDriver?) ||
                    VehicleAssignmentAssigning(:final currentDriver?) ||
                    VehicleAssignmentAssignmentSuccess(
                      :final currentDriver?,
                    ) => AssignedDriverCard(
                      driver: currentDriver,
                      onChangeDriver: () => _openDriverSelection(context),
                    ),
                    _ => _EmptyDriverCard(
                      onAssign: () => _openDriverSelection(context),
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: assignmentCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.bgprimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    // maxLines 1 juga menjaga tinggi intrinsik tetap satu baris.
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey500,
                    ),
                  ),
                ),
              ),
              
            ],
          ),
          // Mendorong nilai ke bawah agar kedua kartu sejajar walau judulnya
          // berbeda panjang.
          const Spacer(),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.grey500,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDriverCard extends StatelessWidget {
  final VoidCallback onAssign;

  const _EmptyDriverCard({required this.onAssign});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: assignmentCardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.bgprimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add_alt_1_rounded,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada pengemudi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tugaskan pengemudi agar kendaraan ini siap digunakan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAssign,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
              // Style di Text (bukan styleFrom.textStyle) agar font tema tetap
              // dipakai.
              label: const Text(
                'Tugaskan Pengemudi',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverLoadingCard extends StatelessWidget {
  const _DriverLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: assignmentCardShadow,
      ),
      child: const Row(
        children: [
          SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Memuat data pengemudi...',
              style: TextStyle(fontSize: 14, color: AppColors.grey500),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DriverErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: assignmentCardShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gagal memuat pengemudi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}
