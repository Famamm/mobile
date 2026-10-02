import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:fleetops_mobile/features/inspection/presentation/blocs/inspection_bloc.dart';
import 'package:fleetops_mobile/features/inspection/presentation/pages/inspection_page.dart';
import 'package:fleetops_mobile/features/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:fleetops_mobile/features/trip/data/models/cancel_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/data/models/get_active_trip_dto.dart';
import 'package:fleetops_mobile/features/trip/domain/repositories/trip_repository.dart';
import 'package:fleetops_mobile/features/trip_history/presentation/blocs/trip_history_bloc.dart';
import 'package:fleetops_mobile/features/trip/presentation/pages/trip_active_page.dart';
import 'package:fleetops_mobile/features/trip_history/presentation/pages/trip_history_page.dart';
import 'package:fleetops_mobile/features/trip/presentation/pages/trip_start_page.dart';

import '../../../dashboard/presentation/blocs/dashboard_bloc.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';
import '../../../profile/presentation/blocs/profile_event.dart';
import '../../../../injection_container.dart';
import '../blocs/bottom_nav_cubit.dart';
import '../blocs/bottom_nav_state.dart';
import '../widgets/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ValueNotifier<bool> _inspectionInProgress = ValueNotifier(false);
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    // Cek Role Admin
    final role = sl<TokenService>().getRoleName();
    if (role == 'Admin') {
      Future.microtask(() {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AdminDashboardPage.routeName);
        }
      });
      return;
    }

    _pages = [
      BlocProvider(
        create: (_) => sl<DashboardBloc>(),
        child: const DashboardPage(),
      ),
      BlocProvider(
        create: (_) => sl<ProfileBloc>()..add(LoadProfileEvent()),
        child: const StartingPage(),
      ),
      BlocProvider(
        create: (_) => sl<InspectionBloc>(),
        child: InspectionPage(inspectionInProgress: _inspectionInProgress),
      ),
      BlocProvider(
        create: (_) => sl<TripHistoryBloc>(),
        child: const TripHistoryPage(),
      ),
    ];
    // Cek trip aktif saat app dibuka
    Future.delayed(Duration.zero, () {
      if (mounted) _checkActiveTrip();
    });
  }

  Future<void> _checkActiveTrip() async {
    final driverId = sl<TokenService>().getDriverId();
    if (driverId == null) return;

    try {
      final repo = sl<TripRepository>();
      final GetActiveTripDTO? active = await repo.getActiveTrip(driverId);
      if (active == null || !mounted) return;

      _showResumeTripDialog(active, repo);
    } catch (_) {}
  }

  void _showResumeTripDialog(GetActiveTripDTO active, TripRepository repo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: Color(0xFF1565C0),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Trip Sedang Berjalan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Kamu masih memiliki trip aktif dari ${active.lokasiAwal} ke ${active.lokasiAkhir ?? '-'}. Ingin melanjutkan atau membatalkan trip?',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushNamed(
                      context,
                      TripActivePage.routeName,
                      arguments: {
                        'startLocation': active.lokasiAwal,
                        'endLocation': active.lokasiAkhir ?? '',
                        'odometerAwal': active.odometerAwal,
                        'tripId': active.tripId.toString(),
                        'startTime': active.waktuMulai,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan Trip',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _cancelActiveTrip(
                      active.tripId,
                      active.driverId,
                      repo,
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                  child: const Text(
                    'Batalkan Trip',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cancelActiveTrip(
    int tripId,
    int driverId,
    TripRepository repo,
  ) async {
    try {
      await repo.cancelTrip(tripId, CancelTripDTO(driverId: driverId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip berhasil dibatalkan'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _inspectionInProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: Scaffold(
        body: BlocBuilder<BottomNavCubit, BottomNavState>(
          builder: (context, state) {
            return IndexedStack(index: state.index, children: _pages);
          },
        ),
        bottomNavigationBar: BottomNavBar(
          inspectionInProgress: _inspectionInProgress,
        ),
      ),
    );
  }
}
