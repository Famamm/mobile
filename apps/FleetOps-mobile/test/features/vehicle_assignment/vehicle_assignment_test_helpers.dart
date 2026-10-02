import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fleetops_mobile/features/driver/data/models/driver_model.dart';
import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';
import 'package:fleetops_mobile/features/vehicle/domain/entities/vehicle.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/entities/vehicle_assignment_entity.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/repositories/vehicle_assignment_repository.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/assign_vehicle_driver_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/get_available_drivers_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/get_current_driver_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/get_vehicle_assignment_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/domain/usecases/unassign_driver_usecase.dart';
import 'package:fleetops_mobile/features/vehicle_assignment/presentation/blocs/vehicle_assignment_bloc.dart';

class FakeVehicleAssignmentRepository implements VehicleAssignmentRepository {
  final List<Vehicle> vehicles;
  List<Driver> drivers;
  Driver? currentDriver;
  Object? currentDriverError;
  Completer<void>? currentDriverGate;
  final assignments = <(int vehicleId, int driverId)>[];

  FakeVehicleAssignmentRepository({
    this.vehicles = const [],
    this.drivers = const [],
    this.currentDriver,
  });

  @override
  Future<VehicleAssignmentEntity> getVehicleAssignment() async =>
      VehicleAssignmentEntity(vehicles: vehicles, drivers: drivers);

  @override
  Future<List<Driver>> getAvailableDrivers() async => drivers;

  @override
  Future<Driver?> getCurrentDriver(int vehicleId) async {
    await currentDriverGate?.future;
    if (currentDriverError != null) throw currentDriverError!;
    return currentDriver;
  }

  @override
  Future<void> assignDriver({
    required int vehicleId,
    required int driverId,
  }) async {
    assignments.add((vehicleId, driverId));
    currentDriver = drivers.firstWhere((d) => d.driverId == driverId);
    drivers = drivers.where((d) => d.driverId != driverId).toList();
  }

  @override
  Future<void> unassignDriver(int vehicleId) async {}
}

VehicleAssignmentBloc buildBloc(VehicleAssignmentRepository repository) =>
    VehicleAssignmentBloc(
      getVehicleAssignmentUseCase: GetVehicleAssignmentUseCase(repository),
      assignVehicleDriverUseCase: AssignVehicleDriverUseCase(repository),
      getCurrentDriverUseCase: GetCurrentDriverUseCase(repository),
      getAvailableDriversUseCase: GetAvailableDriversUseCase(repository),
      unassignDriverUseCase: UnassignDriverUseCase(repository),
    );

Vehicle buildVehicle({
  int vehicleId = 1,
  String status = 'Active',
  String platNomor = 'AB 1234 CDE',
}) => Vehicle(
  vehicleId: vehicleId,
  driverId: 0,
  vehicleName: 'Toyota Hiace',
  platNomor: platNomor,
  tahunPembuatan: 2020,
  odometer: 48250,
  tipe: 'Mobil',
  status: status,
  muatanMax: 0,
  tipeBensin: 'Diesel',
);

/// Sama seperti data source lama: hasilnya `List<DriverModel>` yang dipakai
/// sebagai `List<Driver>`, sehingga regresi crash `orElse` ikut teruji.
List<Driver> driversFromJson(List<Map<String, dynamic>> json) =>
    json.map(DriverModel.fromJson).toList();

void setScreen(WidgetTester tester, Size size, {double textScale = 1}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}
