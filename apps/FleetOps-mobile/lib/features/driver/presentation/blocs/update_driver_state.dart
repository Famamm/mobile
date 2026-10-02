import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

abstract class UpdateDriverState {}

class UpdateDriverInitial extends UpdateDriverState {}

class UpdateDriverLoading extends UpdateDriverState {}

class UpdateDriverSuccess extends UpdateDriverState {
  final Driver driver;
  UpdateDriverSuccess(this.driver);
}

class UpdateDriverError extends UpdateDriverState {
  final String message;
  UpdateDriverError(this.message);
}
