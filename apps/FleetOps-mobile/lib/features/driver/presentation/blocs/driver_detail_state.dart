import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

abstract class DriverDetailState {}

class DriverDetailInitial extends DriverDetailState {}

class DriverDetailLoading extends DriverDetailState {}

class DriverDetailLoaded extends DriverDetailState {
  final Driver driver;

  DriverDetailLoaded(this.driver);
}

class DriverDetailDeleteSuccess extends DriverDetailState {}

class DriverDetailError extends DriverDetailState {
  final String message;

  DriverDetailError(this.message);
}
