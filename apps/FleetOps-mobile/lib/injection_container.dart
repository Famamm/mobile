// lib/injection_container.dart

import 'package:core/core.dart';
import 'package:fleetops_mobile/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:fleetops_mobile/features/dashboard/data/data_sources/admin_dashboard_remote_data_source_impl.dart';
import 'package:fleetops_mobile/features/dashboard/data/repositories/admin_dashboard_repository_impl.dart';
import 'package:fleetops_mobile/features/dashboard/domain/repositories/admin_dashboard_repository.dart';
import 'package:fleetops_mobile/features/driver/data/data_sources/driver_remote_data_source.dart';
import 'package:fleetops_mobile/features/driver/data/data_sources/driver_remote_data_source_impl.dart';
import 'package:fleetops_mobile/features/driver/data/repositories/driver_repository_impl.dart';
import 'package:fleetops_mobile/features/driver/domain/repositories/driver_repository.dart';
import 'package:fleetops_mobile/features/driver/presentation/blocs/create_driver_bloc.dart';
import 'package:fleetops_mobile/features/driver/presentation/blocs/driver_list_bloc.dart';
import 'package:fleetops_mobile/features/driver/presentation/blocs/reset_driver_password_bloc.dart';
import 'package:fleetops_mobile/features/driver/presentation/blocs/update_driver_bloc.dart';
import 'package:fleetops_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fleetops_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:fleetops_mobile/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:fleetops_mobile/features/fleet_manager/data/data_sources/fleet_manager_remote_data_source.dart';
import 'package:fleetops_mobile/features/fleet_manager/data/repositories/fleet_manager_repository_impl.dart';
import 'package:fleetops_mobile/features/fleet_manager/domain/repositories/fleet_manager_repository.dart';
import 'package:fleetops_mobile/features/fleet_manager/presentation/blocs/fleet_manager_bloc.dart';
import 'package:fleetops_mobile/features/statistic/data/data_sources/statistic_remote_data_source.dart';
import 'package:fleetops_mobile/features/statistic/data/repositories/statistic_repository_impl.dart';
import 'package:fleetops_mobile/features/statistic/domain/repositories/statistic_repository.dart';
import 'package:fleetops_mobile/features/statistic/domain/usecases/get_statistic_usecase.dart';
import 'package:fleetops_mobile/features/statistic/presentation/blocs/statistic_bloc.dart';
import 'package:fleetops_mobile/features/trip_history/data/data_sources/history_data_source.dart';
import 'package:fleetops_mobile/features/trip_history/data/data_sources/history_data_source_impl.dart';
import 'package:fleetops_mobile/features/trip_history/data/repositories/history_repository_impl.dart';
import 'package:fleetops_mobile/features/trip_history/domain/repositories/history_repository.dart';
import 'package:fleetops_mobile/features/trip_history/presentation/blocs/trip_history_bloc.dart';
import 'package:fleetops_mobile/features/trip/data/data_sources/trip_remote_data_source.dart';
import 'package:fleetops_mobile/features/trip/data/data_sources/trip_remote_data_source_impl.dart';
import 'package:fleetops_mobile/features/trip/data/repositories/trip_repostiory_impl.dart';
import 'package:fleetops_mobile/features/trip/domain/repositories/trip_repository.dart';
import 'package:fleetops_mobile/features/trip/presentation/blocs/cancel_trip_bloc.dart';
import 'package:fleetops_mobile/features/trip/presentation/blocs/end_trip_bloc.dart';
import 'package:fleetops_mobile/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:fleetops_mobile/features/users/data/data_sources/user_remote_data_source_impl.dart';
import 'package:fleetops_mobile/features/users/data/repositories/user_repository_impl.dart';
import 'package:fleetops_mobile/features/users/domain/repositories/user_repository.dart';
import 'package:fleetops_mobile/features/users/presentation/blocs/user_list_bloc.dart';
import 'package:fleetops_mobile/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import 'package:fleetops_mobile/features/vehicle/data/data_sources/vehicle_remote_data_source_impl.dart';
import 'package:fleetops_mobile/features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'package:fleetops_mobile/features/vehicle/domain/repositories/vehicle_repository.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/blocs/add_vehicle_bloc.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/blocs/admin_vehicle_list_bloc.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/blocs/delete_vehicle_bloc.dart';
import 'package:fleetops_mobile/features/vehicle/presentation/blocs/update_vehicle_bloc.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/data/data_sources/vehicle_assignment_remote_data_source.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/data/data_sources/vehicle_assignment_remote_data_source_impl.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/data/repositories/vehicle_assignment_repository_impl.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/repositories/vehicle_assignment_repository.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/assign_vehicle_driver_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/get_vehicle_assignment_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/get_current_driver_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/get_available_drivers_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/unassign_driver_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/blocs/vehicle_assignment_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'features/dashboard/data/data_sources/dashboard_remote_data_source_impl.dart';
import 'features/dashboard/data/data_sources/fleet_dashboard_remote_data_source.dart';
import 'features/dashboard/data/data_sources/fleet_dashboard_remote_data_source_impl.dart';
import 'features/dashboard/data/data_sources/admin_dashboard_remote_data_source.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/data/repositories/fleet_dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/repositories/fleet_dashboard_repository.dart';
import 'features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'features/dashboard/presentation/blocs/fleet_dashboard_bloc.dart';
import 'features/fleet_manager/data/data_sources/fleet_manager_remote_data_source_impl.dart';
import 'features/fleet_manager/presentation/blocs/fleet_manager_detail_bloc.dart';
import 'features/notification/data/data_sources/notification_remote_data_source.dart';
import 'features/notification/data/data_sources/notification_remote_data_source_impl.dart';
import 'features/notification/data/repositories/notification_repository_impl.dart';
import 'features/notification/domain/repositories/notification_repository.dart';
import 'features/notification/domain/usecases/get_notification_usecase.dart';
import 'features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'features/notification/presentation/blocs/notification_bloc.dart';
import 'features/profile/data/data_sources/profile_remote_data_source.dart';
import 'features/profile/data/data_sources/profile_remote_data_source_impl.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_admin_profile_usecase.dart';
import 'features/profile/domain/usecases/get_fleet_profile_usecase.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/select_vehicle_usecase.dart';
import 'features/profile/presentation/blocs/admin_profile_bloc.dart';
import 'features/profile/presentation/blocs/fleet_profile_bloc.dart';
import 'features/profile/presentation/blocs/profile_bloc.dart';
import 'features/inspection/data/data_sources/inspection_remote_data_source.dart';
import 'package:fleetops_mobile/features/inspection/data/data_sources/inspection_remote_data_source_impl.dart'
    as inspection_impl;
import 'features/inspection/data/repositories/inspection_repository_impl.dart';
import 'features/inspection/domain/repositories/inspection_repository.dart';
import 'features/inspection/domain/usecases/submit_inspection_usecase.dart';
import 'features/inspection/presentation/blocs/inspection_bloc.dart';
import 'features/dashboard/presentation/blocs/admin_dashboard_bloc.dart';
import 'features/fuel/data/datasources/fuel_remote_data_source.dart';
import 'features/fuel/data/repositories/fuel_repository_impl.dart';
import 'features/fuel/domain/repositories/fuel_repository.dart';
import 'features/fuel/domain/usecases/create_fuel_usecase.dart';
import 'features/fuel/domain/usecases/delete_fuel_usecase.dart';
import 'features/fuel/domain/usecases/get_fuel_prices_usecase.dart';
import 'features/fuel/presentation/bloc/fuel_bloc.dart';
import 'features/trip/data/data_sources/trip_gps_remote_data_source.dart';
import 'features/trip/data/repositories/trip_gps_repository_impl.dart';
import 'features/trip/domain/repositories/trip_gps_repository.dart';
import 'features/trip/presentation/blocs/damage_report_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==================== STEP 1: Shared Preferences (MUST BE FIRST) ====================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // ==================== STEP 2: Token Service ====================
  sl.registerSingleton<TokenService>(TokenService(prefs: sl()));

  // ==================== STEP 3: Http Service (with TokenService) ====================
  sl.registerSingleton<HttpService>(HttpService());

  // ==================== STEP 4: Auth ====================
  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(
    () => AuthBloc(repository: sl(), tokenService: sl(), httpService: sl()),
  );

  // ==================== STEP 5: Vehicle ====================
  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory<AddVehicleBloc>(
    () => AddVehicleBloc(repository: sl<VehicleRepository>()),
  );

  sl.registerFactory<AdminVehicleListBloc>(
    () => AdminVehicleListBloc(
      repository: sl<VehicleRepository>(),
      tokenService: sl<TokenService>(),
    ),
  );

  sl.registerFactory<UpdateVehicleBloc>(
    () => UpdateVehicleBloc(repository: sl<VehicleRepository>()),
  );

  sl.registerFactory(() => VehicleDeleteBloc(vehicleRepository: sl()));

  sl.registerLazySingleton<VehicleAssignmentRemoteDataSource>(
    () => VehicleAssignmentRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<VehicleAssignmentRepository>(
    () => VehicleAssignmentRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetVehicleAssignmentUseCase(sl()));
  sl.registerLazySingleton(() => AssignVehicleDriverUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentDriverUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableDriversUseCase(sl()));
  sl.registerLazySingleton(() => UnassignDriverUseCase(sl()));

  sl.registerFactory<VehicleAssignmentBloc>(
    () => VehicleAssignmentBloc(
      getVehicleAssignmentUseCase: sl<GetVehicleAssignmentUseCase>(),
      assignVehicleDriverUseCase: sl<AssignVehicleDriverUseCase>(),
      getCurrentDriverUseCase: sl<GetCurrentDriverUseCase>(),
      getAvailableDriversUseCase: sl<GetAvailableDriversUseCase>(),
      unassignDriverUseCase: sl<UnassignDriverUseCase>(),
    ),
  );

  // ==================== STEP 6: Driver ====================
  // Driver
  sl.registerLazySingleton<DriverRemoteDataSource>(
    () => DriverRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<DriverRepository>(
    () => DriverRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory<DriverListBloc>(
    () => DriverListBloc(repository: sl<DriverRepository>()),
  );

  sl.registerFactory<CreateDriverBloc>(
    () => CreateDriverBloc(repository: sl<DriverRepository>()),
  );

  sl.registerFactory<UpdateDriverBloc>(
    () => UpdateDriverBloc(repository: sl<DriverRepository>()),
  );

  sl.registerFactory<ResetDriverPasswordBloc>(
    () => ResetDriverPasswordBloc(repository: sl<DriverRepository>()),
  );

  // ==================== STEP 7: Dashboard ====================
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));
  sl.registerFactory(() => DashboardBloc(getDashboard: sl()));

  // ==================== STEP 8: Trip ====================
  sl.registerSingleton<TripRemoteDataSource>(
    TripRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerSingleton<TripRepository>(
    TripRepositoryImpl(remoteDataSource: sl()),
  );

  // ==================== STEP 9: History ====================
  sl.registerSingleton<HistoryDataSource>(
    HistoryDataSourceImpl(httpService: sl()),
  );

  sl.registerSingleton<HistoryRepository>(
    HistoryRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory<TripHistoryBloc>(
    () => TripHistoryBloc(repository: sl<HistoryRepository>()),
  );

  sl.registerFactory<EndTripBloc>(() => EndTripBloc(repository: sl()));

  sl.registerFactory<CancelTripBloc>(() => CancelTripBloc(repository: sl()));

  // ==================== STEP 10: Profile ====================
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => SelectVehicleUseCase(sl()));
  sl.registerFactory(() => ProfileBloc(getProfile: sl()));

  sl.registerLazySingleton(() => GetAdminProfileUseCase(sl()));
  sl.registerFactory(() => AdminProfileBloc(getAdminProfile: sl()));

  // ==================== STEP 11: Inspection ====================
  sl.registerLazySingleton<InspectionRemoteDataSource>(
    () => inspection_impl.InspectionRemoteDataSourceImpl(
      httpClientService: sl<HttpService>(),
    ),
  );

  sl.registerLazySingleton<InspectionRepository>(
    () => InspectionRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => SubmitInspectionUseCase(sl()));

  sl.registerFactory(
    () => InspectionBloc(
      submitInspectionUseCase: sl(),
      inspectionRepository: sl(),
    ),
  );

  // NOTIFICATION
  // Data Source
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(httpService: sl<HttpService>()),
  );

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
    ),
  );

  // UseCase
  sl.registerLazySingleton<GetNotificationUseCase>(
    () => GetNotificationUseCase(repository: sl<NotificationRepository>()),
  );

  // BLoC (factory, karena tiap halaman butuh instance baru)
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      getNotificationsUseCase: sl<GetNotificationUseCase>(),
      markNotificationAsReadUseCase: sl<MarkNotificationAsReadUseCase>(),
    ),
  );

  sl.registerLazySingleton<MarkNotificationAsReadUseCase>(
    () =>
        MarkNotificationAsReadUseCase(repository: sl<NotificationRepository>()),
  );

  sl.registerFactory(() => DamageReportBloc(repository: sl<TripRepository>()));

  // PROFILE
  // Register usecase (kalau pakai clean architecture)
  sl.registerLazySingleton(() => GetFleetProfileUseCase(sl()));

  // Register bloc
  sl.registerFactory(() => FleetProfileBloc(getFleetProfile: sl()));

  // ==================== STEP 12: Admin Dashboard ====================
  // Data Source
  sl.registerLazySingleton<AdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(httpService: sl<HttpService>()),
  );

  // Repository
  sl.registerLazySingleton<AdminDashboardRepository>(
    () => AdminDashboardRepositoryImpl(
      remoteDataSource: sl<AdminDashboardRemoteDataSource>(),
    ),
  );

  // Bloc
  sl.registerFactory(
    () => AdminDashboardBloc(
      adminDashboardRepository: sl<AdminDashboardRepository>(),
    ),
  );

  // Data source
  sl.registerLazySingleton<TripGpsRemoteDataSource>(
    () => TripGpsRemoteDataSourceImpl(sl<HttpService>()),
  );

  // Repository
  sl.registerLazySingleton<TripGpsRepository>(
    () => TripGpsRepositoryImpl(sl()),
  );

  // ── Users ─────────────────────────────────────────────────
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl<UserRemoteDataSource>()),
  );

  sl.registerFactory(() => UserListBloc(repository: sl<UserRepository>()));

  sl.registerFactory(
    () => FleetManagerDetailBloc(repository: sl<FleetManagerRepository>()),
  );

  // ── Fleet Dashboard ──
  sl.registerLazySingleton<FleetDashboardRemoteDataSource>(
    () => FleetDashboardRemoteDataSourceImpl(httpService: sl<HttpService>()),
  );

  sl.registerLazySingleton<FleetDashboardRepository>(
    () => FleetDashboardRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => FleetDashboardBloc(fleetDashboardRepository: sl()));

  // ── Fleet Manager ────────────────────────────────────────
  // Data Source
  sl.registerLazySingleton<FleetManagerRemoteDataSource>(
    () => FleetManagerRemoteDataSourceImpl(httpService: sl()),
  );

  // Repository
  sl.registerLazySingleton<FleetManagerRepository>(
    () => FleetManagerRepositoryImpl(
      remoteDataSource: sl<FleetManagerRemoteDataSource>(),
    ),
  );

  // Bloc Form (create + edit)
  sl.registerFactory(
    () => FleetManagerFormBloc(repository: sl<FleetManagerRepository>()),
  );

  // ==================== Statistic ====================
  sl.registerLazySingleton<StatisticRemoteDataSource>(
    () => StatisticRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<StatisticRepository>(
    () => StatisticRepositoryImpl(
      remoteDataSource: sl<StatisticRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton(() => GetStatisticUseCase(sl()));
  sl.registerFactory(() => StatisticBloc(getStatistic: sl()));

  // ==================== STEP 13: Fuel ====================
  sl.registerLazySingleton<FuelRemoteDataSource>(
    () => FuelRemoteDataSourceImpl(httpService: sl()),
  );

  sl.registerLazySingleton<FuelRepository>(
    () => FuelRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetFuelPricesUsecase(sl()));
  sl.registerLazySingleton(() => CreateFuelUsecase(sl()));
  sl.registerLazySingleton(() => DeleteFuelUsecase(sl()));

  sl.registerFactory(
    () => FuelBloc(
      getFuelPricesUsecase: sl(),
      createFuelUsecase: sl(),
      deleteFuelUsecase: sl(),
    ),
  );
}
