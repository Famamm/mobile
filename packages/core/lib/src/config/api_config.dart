class ApiConfig {
  // // Base URL untuk backend ASP.NET
  static const String baseUrl ='https://api.fleetops.my.id/';
  // static const String baseUrl = 'https://edging-retying-book.ngrok-free.dev/';

  // AUTHENTICATION
  static const String loginEndpoint = 'api/auth/login';
  static const String registerEndpoint = 'api/auth/register';
  static const String refreshTokenEndpoint = 'api/auth/refresh';
  static const String logoutEndpoint = 'api/auth/logout';
  static const String logoutAllDevicesEndpoint = 'api/auth/logout-all';

  // ADMIN
  // ADMIN - VEHICLE
  static const String adminCreateVehicleEndpoint = 'api/admin/vehicles'; //done
  static const String adminGetAllVehicleEndpoint = 'api/admin/vehicles'; //done
  static const String adminUpdateVehicleEndpoint =
      'api/admin/vehicles/{vehicleId}'; //done
  static const String adminDeleteVehicleEndpoint =
      'api/admin/vehicles/{vehicleId}'; //done
  static const String adminGetByIdVehicleEndpoint =
      'api/admin/vehicles/{vehicleId}'; //done

  // ADMIN - DRIVER
  static const String adminCreateDriverEndpoint = 'api/admin/drivers'; //done
  static const String adminGetAllDriverEndpoint = 'api/admin/drivers'; //done
  static const String adminGetByIdDriverEndpoint =
      'api/admin/drivers/{driverId}'; //done
  static const String adminUpdateDriverEndpoint =
      'api/admin/drivers/{driverId}'; //done
  static const String adminDeleteDriverEndpoint =
      'api/admin/drivers/{driverId}'; //done
  static const String adminResetDriverPasswordEndpoint =
      'api/admin/drivers/{driverId}/password/reset'; //done

  // ADMIN - FLEET MANAGER
  static const String adminCreateFleetManagerEndpoint =
      'api/admin/fleet-managers'; //done
  static const String adminUpdateFleetManagerEndpoint =
      'api/admin/fleet-managers/{userId}'; //done
  static const String adminDeleteFleetManagerEndpoint =
      'api/admin/fleet-managers/{userId}'; //done
  static const String adminDetailFleetManagerEndpoint =
      'api/admin/fleet-managers/{userId}'; //done
  static const String adminResetFleetManagerPasswordEndpoint =
      'api/admin/fleet-managers/{userId}/password/reset'; //done

  // ADMIN - USERS
  static const String adminGetAllUserEndpoint = 'api/admin/users'; //done

  // ADMIN - PROFILE & DASHBOARD
  static const String adminGetProfile = 'api/admin/profile/me'; //done
  static const String adminUpdateProfile = 'api/admin/profile/me';
  static const String adminGetDashboard = 'api/admin/dashboard/me'; //done
  static const String adminGetStatistics = 'api/admin/statistics'; //done

  // FLEET
  // FLEET - NOTIFICATION
  static const String fleetGetNotificationsEndpoint =
      'api/fleet-manager/notifications';
  static const String fleetReadNotificationEndpoint =
      'api/fleet-manager/notifications/{notificationId}/read';
  static const String fleetReadAllNotificationsEndpoint =
      'api/fleet-manager/notifications/read-all';

  // FLEET - PROFILE & DASHBOARD
  static const String fleetGetProfile = 'api/fleet-manager/profile/me';
  static const String fleetUpdateProfile = 'api/fleet-manager/profile/me';
  static const String fleetGetDashboardEndpoint = 'api/fleet-manager/summary';
  static const String fleetGetStatisticsEndpoint =
      'api/fleet-manager/statistics';
  static const String fleetVehicleSummaryEndpoint = 'api/fleet-manager/summary';
  static const String fleetVehicleListEndpoint = 'api/fleet-manager/vehicles';
  static const String fleetAssignmentEndpoint = 'api/fleet-manager/assignments';
  static const String fleetAvailableDriversEndpoint =
      'api/fleet-manager/drivers/available';
  static const String fleetCurrentDriverEndpoint =
      'api/fleet-manager/vehicles/{vehicleId}/current-driver';
  static const String fleetUnassignDriverEndpoint =
      'api/fleet-manager/vehicles/{vehicleId}/driver';

  // DRIVER
  // DRIVER - PROFILE & DASHBOARD
  static const String driverGetProfileEndpoint =
      'api/drivers/profile/me'; //done tapi kendaraan tidak ada
  static const String driverSelectVehicleEndpoint =
      'api/drivers/profile/me/vehicle'; //dicoba di postman masih error
  static const String driverGetDashboardEndpoint =
      'api/drivers/dashboard/me'; //done

  // DRIVER - FUEL (BBM)
  static const String driverCreateFuelEndpoint =
      'api/drivers/fuel'; //done belum cek
  static const String driverGetFuelPricesEndpoint =
      'api/drivers/fuel/prices'; //done belum cek
  static const String driverGetFuelEfficiencyEndpoint =
      'api/drivers/fuel/efficiency';
  static const String driverGetFuelHistoryEndpoint =
      'api/drivers/fuel/history'; //done
  static const String driverGetFuelByIdEndpoint =
      'api/drivers/fuel/{fuelId}'; //done

  // DRIVER - INSPECTION (belum selesai)
  static const String driverCreateInspectionEndpoint =
      'api/drivers/inspections'; //done
  static const String driverGetInspectionsByDriverEndpoint =
      'api/drivers/inspections/driver/{driverId}'; //done
  static const String driverGetMyInspectionsEndpoint =
      'api/drivers/inspections/me';
  static const String driverGetMyTodayInspectionsEndpoint =
      'api/drivers/inspections/me/today'; //done
  static const String driverGetInspectionsByVehicleEndpoint =
      'api/drivers/inspections/vehicle/{vehicleId}'; //done
  static const String driverGetInspectionByIdEndpoint =
      'api/drivers/inspections/{inspectionId}'; //done
  static const String driverUpdateInspectionEndpoint =
      'api/drivers/inspections/{inspectionId}'; //done
  static const String driverDeleteInspectionEndpoint =
      'api/drivers/inspections/{inspectionId}'; //done
  static const String driverGetInspectionItemsEndpoint =
      'api/drivers/inspections/inspection-items'; //done

  // DRIVER - TRIP
  static const String driverStartTripEndpoint =
      'api/drivers/trips'; //done tapi belum cek
  static const String driverStopTripEndpoint =
      'api/drivers/trips/{tripId}/stop'; //done tapi belum cek
  static const String driverCancelTripEndpoint =
      'api/drivers/trips/{tripId}/cancel'; //done tapi belum cek
  static const String driverGetTripsHistoryEndpoint =
      'api/drivers/trips/driver/{driverId}'; //done
  static const String driverGetTripByIdEndpoint =
      'api/drivers/trips/{tripId}'; //done
  static const String driverGetActiveTripByDriverEndpoint =
      'api/drivers/trips/driver/{driverId}/active'; //done tapi belum cek

  // DRIVER - TRIP REPORTS
  static const String driverDamageReportEndpoint =
      'api/drivers/trips/{tripId}/damage-reports';

  // Vehicle Endpoints
  static const String getVehicleListEndpoint = 'api/vehicles/{driverId}';

  // Timeout durations
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int sendTimeoutSeconds = 30;
  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
