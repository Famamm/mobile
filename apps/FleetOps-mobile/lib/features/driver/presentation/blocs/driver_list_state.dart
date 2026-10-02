import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

abstract class DriverListState {}

class DriverListInitial extends DriverListState {}

class DriverListLoading extends DriverListState {}

class DriverListLoaded extends DriverListState {
  final List<Driver> drivers;
  DriverListLoaded(this.drivers);
}

class DriverListError extends DriverListState {
  final String message;
  DriverListError(this.message);
}

class DriverDeleteSuccess extends DriverListState {}
