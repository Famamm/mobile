import 'fleet_manager_model.dart';

class CreateFleetManagerResponseModel {
  final String message;
  final FleetManagerModel fleetManager;
  final String generatedPassword;

  const CreateFleetManagerResponseModel({
    required this.message,
    required this.fleetManager,
    required this.generatedPassword,
  });

  factory CreateFleetManagerResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateFleetManagerResponseModel(
      message: json['message'] ?? '',
      fleetManager: FleetManagerModel.fromJson(json),
      generatedPassword: json['generatedPassword'] ?? '',
    );
  }
}