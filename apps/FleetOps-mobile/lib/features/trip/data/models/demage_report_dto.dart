// features/trip/data/models/damage_report_dto.dart
import 'dart:io';

class DamageReportDTO {
  final int tripId;
  final int driverId;
  final int vehicleId;
  final int operationalStatus;
  final int severity;
  final String damageType;
  final String? note;
  final String location;
  final int odometer;
  final File? image;

  DamageReportDTO({
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

  /// Field untuk multipart — semua String
  Map<String, String> toMultipartFields() => {
        'tripId': tripId.toString(),
        'driverId': driverId.toString(),
        'vehicleId': vehicleId.toString(),
        'OperationalStatus': operationalStatus.toString(),
        'Severity': severity.toString(),
        'DamageType': damageType,
        'Note': note ?? '',
        'Location': location,
        'Odometer': odometer.toString(),
      };

  /// Field untuk JSON (tanpa file)
  Map<String, dynamic> toJson() => {
        'tripId': tripId,
        'driverId': driverId,
        'vehicleId': vehicleId,
        'OperationalStatus': operationalStatus,
        'Severity': severity,
        'DamageType': damageType,
        'Note': note ?? '',
        'Location': location,
        'Odometer': odometer,
      };
}