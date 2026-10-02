import 'package:core/core.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_event.dart';
import 'package:fleetops_mobile/features/auth/presentation/pages/create_organization_page.dart';
import 'package:fleetops_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:fleetops_mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:fleetops_mobile/features/inspection/presentation/pages/inspection_page.dart';
import 'package:fleetops_mobile/features/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:fleetops_mobile/features/profile/presentation/pages/admin/admin_profile_page.dart';
import 'package:fleetops_mobile/features/trip/presentation/blocs/start_trip_bloc.dart';
import 'package:fleetops_mobile/features/trip_history/presentation/blocs/trip_history_bloc.dart';
import 'package:fleetops_mobile/features/trip/presentation/pages/trip_active_page.dart';
import 'package:fleetops_mobile/features/trip/presentation/pages/trip_detail_page.dart';
import 'package:fleetops_mobile/features/trip/presentation/pages/trip_start_page.dart';
import 'package:fleetops_mobile/features/trip_history/presentation/pages/trip_history_page.dart';
import 'package:fleetops_mobile/features/navigation/presentation/pages/main_page.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/blocs/add_vehicle_bloc.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/pages/add_vehicle_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/fleet_dashboard_page.dart';
import 'features/fleet_manager/presentation/pages/admin_add_fleet_manager_page.dart';
import 'features/notification/presentation/blocs/notification_bloc.dart';
import 'features/profile/presentation/pages/fleet_manager/fleet_profile_page.dart';
import 'injection_container.dart' as di;

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Restore token ke HttpService supaya semua request langsung pakai token
  final savedToken = di.sl<TokenService>().getToken();
  if (savedToken != null) {
    HttpService.setToken(savedToken);
  }

  // Wire up auto-refresh: inject TokenService dan callback force logout
  di.sl<HttpService>().configure(
    tokenService: di.sl<TokenService>(),
    onUnauthorized: () async {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        LoginPage.routeName,
        (route) => false,
      );
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationBloc>(
          create: (context) => di.sl<NotificationBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthEvent()),
        ),
        BlocProvider<TripHistoryBloc>(
          create: (context) => di.sl<TripHistoryBloc>(),
        ),
        BlocProvider<StartTripBloc>(
          create: (context) => di.sl<StartTripBloc>(),
        ),
        BlocProvider<AddVehicleBloc>(
          create: (context) => di.sl<AddVehicleBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FleetOps',
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        theme: ThemeData(
          textTheme: GoogleFonts.dmSansTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.backgroundLight,
          cardTheme: CardThemeData(
            color: AppColors.white,
            elevation: 3.0,
            shadowColor: AppColors.grey100.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
        home: SplashPage(),
        routes: {
          AdminProfilePage.routeName: (context) => const AdminProfilePage(),
          AdminDashboardPage.routeName: (context) => const AdminDashboardPage(),
          FleetDashboardPage.routeName: (context) => const FleetDashboardPage(),
          FleetProfilePage.routeName: (context) => const FleetProfilePage(),
          InspectionPage.routeName: (context) => const InspectionPage(),
          CreateOrganizationPage.routeName: (context) =>
              const CreateOrganizationPage(),
          AddVehiclePage.routeName: (context) => const AddVehiclePage(),
          WelcomePage.routeName: (context) => const WelcomePage(),
          TripDetailPage.routeName: (context) => const TripDetailPage(),
          TripHistoryPage.routeName: (context) => const TripHistoryPage(),
          MainPage.routeName: (context) => const MainPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          StartingPage.routeName: (context) => const StartingPage(),
          AdminAddFleetManagerPage.routeName: (context) =>
              const AdminAddFleetManagerPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == TripActivePage.routeName) {
            final args = settings.arguments as Map<String, dynamic>;
            final odometerAwal = args['odometerAwal'] as int;
            final tripId = args['tripId'] as String?;
            final startLocation = args['startLocation'] as String;
            final startTime = args['startTime'] as DateTime?;
            return MaterialPageRoute(
              builder: (_) => TripActivePage(
                startLocation: startLocation,
                odometerAwal: odometerAwal,
                tripId: tripId,
                startTime: startTime,
              ),
            );
          }
          if (settings.name == TripHistoryPage.routeName) {
            return MaterialPageRoute(builder: (_) => const TripHistoryPage());
          }
          if (settings.name == MainPage.routeName) {
            return MaterialPageRoute(builder: (_) => const MainPage());
          }
          // Return null untuk routes yang tidak di-handle
          return null;
        },
      ),
    );
  }
}
