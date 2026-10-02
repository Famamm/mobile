import 'dart:io';

abstract class FleetManagerFormEvent {}

class SubmitCreateFleetManager extends FleetManagerFormEvent {
  final String fullName;
  final String address;
  final String phoneNumber;
  final File? profilePhoto;

  SubmitCreateFleetManager({
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    this.profilePhoto,
  });
}

class SubmitUpdateFleetManager extends FleetManagerFormEvent {
  final int userId;
  final String fullName;
  final String address;
  final String phoneNumber;
  final File? profilePhoto;

  SubmitUpdateFleetManager({
    required this.userId,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    this.profilePhoto,
  });
}

class ResetFleetManagerForm extends FleetManagerFormEvent {}