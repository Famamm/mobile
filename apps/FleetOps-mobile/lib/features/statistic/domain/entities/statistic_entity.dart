import 'package:equatable/equatable.dart';

import 'daily_activity_entity.dart';

class StatisticEntity extends Equatable {
  final int month;
  final int year;
  final int totalVehicles;
  final int activeVehicles;
  final int vehiclesInService;
  final int inactiveVehicles;
  final int totalTrips;
  final double totalDistance;
  final double totalFuel;
  final int totalCost;
  final List<String> fuelTypes;
  final List<DailyActivityEntity> dailyActivity;

  const StatisticEntity({
    required this.month,
    required this.year,
    required this.totalVehicles,
    required this.activeVehicles,
    required this.vehiclesInService,
    required this.inactiveVehicles,
    required this.totalTrips,
    required this.totalDistance,
    required this.totalFuel,
    required this.totalCost,
    required this.fuelTypes,
    required this.dailyActivity,
  });

  @override
  List<Object> get props => [
    month,
    year,
    totalVehicles,
    activeVehicles,
    vehiclesInService,
    inactiveVehicles,
    totalTrips,
    totalDistance,
    totalFuel,
    totalCost,
    fuelTypes,
    dailyActivity,
  ];
}
