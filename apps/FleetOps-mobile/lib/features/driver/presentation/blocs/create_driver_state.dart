import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

abstract class CreateDriverState {}

class CreateDriverInitial extends CreateDriverState {}

class CreateDriverLoading extends CreateDriverState {}

class CreateDriverSuccess extends CreateDriverState {
  final Driver driver;
  final String? generatedUsername;
  final String? generatedPassword;
  CreateDriverSuccess(this.driver,
      {this.generatedUsername, this.generatedPassword});
}

class CreateDriverError extends CreateDriverState {
  final String message;
  CreateDriverError(this.message);
}
