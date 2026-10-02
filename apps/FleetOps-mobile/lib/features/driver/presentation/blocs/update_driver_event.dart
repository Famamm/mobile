import 'dart:io';
import 'package:fleetops_mobile/features/driver/domain/entities/driver.dart';

abstract class UpdateDriverEvent {}

class UpdateDriverSubmitted extends UpdateDriverEvent {
  final Driver driver;
  final File? profilePhoto;
  final File? licensePhoto;

  UpdateDriverSubmitted({
    required this.driver,
    this.profilePhoto,
    this.licensePhoto,
  });
}
