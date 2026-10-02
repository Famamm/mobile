import 'dart:io';

abstract class DamageReportEvent {}

class SubmitDamageReport extends DamageReportEvent {
  final int tripId;
  final int driverId;
  final int vehicleId;
  final String operationalStatus;
  final String severity;
  final String damageType;
  final String? note;
  final String location;
  final int odometer;
  final File? image;

  SubmitDamageReport({
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.operationalStatus,
    required this.severity,
    required this.damageType,
    this.note,
    required this.location,
    required this.odometer,
    this.image,
  });
}

class ResetDamageReport extends DamageReportEvent {}