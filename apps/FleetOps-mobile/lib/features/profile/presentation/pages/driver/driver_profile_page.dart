import 'dart:async';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_event.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_state.dart';
import 'package:fleetops_mobile/features/profile/presentation/widgets/profile_skeleton.dart';

import '../../../../../main.dart';
import '../../../../auth/presentation/pages/welcome_page.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../blocs/profile_bloc.dart';
import '../../blocs/profile_event.dart';
import '../../blocs/profile_state.dart';
import '../../widgets/document_card.dart';
import '../../widgets/logout_confirmation_dialog.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/profile_stats_row.dart';
import '../../widgets/vehicle_card.dart';
import '../app_infromation.dart';

class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({super.key});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> with RouteAware {
  bool _subscribed = false;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route != null && !_subscribed) {
        routeObserver.subscribe(this, route);
        _subscribed = true;
      }
    });

    // Start auto refresh ketika halaman pertama kali dibuka
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _reload();
    // Restart auto refresh ketika kembali ke halaman ini
    _startAutoRefresh();
  }

  @override
  void didPush() {
    super.didPush();
    // Start auto refresh ketika halaman pertama kali di-push
    _startAutoRefresh();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    // Stop auto refresh ketika navigasi ke halaman lain
    _stopAutoRefresh();
  }

  void _startAutoRefresh() {
    _stopAutoRefresh(); // Hentikan timer yang lama jika ada

    _autoRefreshTimer = Timer.periodic(
      const Duration(
        seconds: 15,
      ), // Refresh setiap 30 detik, sesuaikan kebutuhan
      (_) {
        if (mounted) {
          _reload();
        }
      },
    );
  }

  void _stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  void _reload() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<ProfileBloc>().add(LoadProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomSimpleAppBar(title: 'Profile'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) async {
              if (state is ProfileLoaded) {
                final tokenService = sl<TokenService>();
                final entity = state.entity;

                if (entity.kendaraanAktif != null) {
                  final activeId = entity.kendaraanAktif!.vehicleId;
                  final fromList = entity.kendaraanTersedia
                      .cast<DriverVehicleItem>()
                      .firstWhere(
                        (v) => v.vehicleId == activeId,
                        orElse: () => entity.kendaraanAktif!,
                      );
                  final odo =
                      fromList.odometer > entity.kendaraanAktif!.odometer
                      ? fromList.odometer
                      : entity.kendaraanAktif!.odometer;
                  await tokenService.saveActiveVehicle(
                    vehicleId: activeId,
                    vehicleName: entity.kendaraanAktif!.vehicleName,
                    platNomor: entity.kendaraanAktif!.platNomor,
                    odometer: odo,
                    tipeBensin: fromList.tipeBensin,
                  );
                  await tokenService.saveLastOdometer(odo);
                }
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.read<ProfileBloc>().add(LoadProfileEvent());
              }
              if (state is AuthInitial) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/welcome', (route) => false);
              }
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return Skeletonizer(
                enabled: true,
                child: const ProfileSkeleton(),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileLoaded) {
              final e = state.entity;

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: ProfileHeader(
                          driverName: e.namaDriver,
                          photoUrl: e.photoUrl,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ProfileStatsRow(
                        totalJarak: e.totalJarak,
                        totalTrip: e.totalTrip,
                      ),
                      if (e.kendaraanAktif != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Kendaraan Aktif',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        VehicleCard(
                          name: e.kendaraanAktif!.vehicleName,
                          plat: e.kendaraanAktif!.platNomor,
                          isActive: true,
                        ),
                      ] else ...[
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.directions_car_outlined,
                                size: 40,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Belum ada kendaraan yang ditetapkan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Kendaraan aktif akan ditampilkan setelah ditetapkan oleh Fleet Manager.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (e.dokumen != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'DOKUMEN',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 1.2,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DocumentCard(
                          label: e.dokumen!.jenisLisensi,
                          expiry: e.dokumen!.tanggalBerlaku.year.toString(),
                          fotoUrl: e.dokumen!.fotoLisensi,
                        ),
                      ],
                      const SizedBox(height: 12),
                      const Text(
                        'Aplikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primary,
                          ),
                          title: const Text('Informasi Aplikasi'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AppInfoPage(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Keluar',
                          color: AppColors.error,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => LogoutConfirmationDialog(
                                onConfirm: () {
                                  Navigator.pop(context);
                                  final refreshToken =
                                      sl<TokenService>().getRefreshToken() ??
                                      '';
                                  context.read<AuthBloc>().add(
                                    LogoutEvent(refreshToken: refreshToken),
                                  );

                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    WelcomePage.routeName,
                                    (route) => false,
                                  );
                                },
                              ),
                            );
                          },
                        ),
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
