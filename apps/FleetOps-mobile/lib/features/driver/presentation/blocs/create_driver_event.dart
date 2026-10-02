import 'dart:io';

abstract class CreateDriverEvent {}

class CreateDriverSubmitted extends CreateDriverEvent {
  final String fullName;
  final String address;
  final String licenseType;
  final String licenseExpiry;
  final File? profilePhoto;
  final File? licensePhoto;

  CreateDriverSubmitted({
    required this.fullName,
    required this.address,
    required this.licenseType,
    required this.licenseExpiry,
    this.profilePhoto,
    this.licensePhoto,
  });
}
