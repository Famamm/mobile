import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.vehicleId,
    required super.driverId,
    super.organizationId,
    required super.vehicleName,
    required super.platNomor,
    required super.tahunPembuatan,
    required super.odometer,
    required super.tipe,
    required super.status,
    required super.muatanMax,
    required super.tipeBensin,
    super.imageUrl,
  });

  static String _tipeBensinLabel(dynamic value) {
    const labels = {0: 'Diesel', 1: 'Bensin'};
    if (value is int) return labels[value] ?? 'Diesel';
    return value.toString();
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleId: json['id'] as int? ?? json['vehicleId'] as int? ?? 0,
      driverId: json['driverId'] as int? ?? 0,
      organizationId: json['organizationId'] as int?,
      vehicleName: json['vehicleName'] as String? ?? '',
      platNomor: json['platNomor'] as String? ?? '',
      tahunPembuatan: json['tahunPembuatan'] as int? ?? 0,
      odometer: json['odometer'] as int? ?? 0,
      tipe: json['tipe'] as String? ?? '',
      status: json['status'] as String? ?? '',
      muatanMax: json['muatanMax'] as int? ?? 0,
      tipeBensin: _tipeBensinLabel(json['tipeBensin']),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'driverId': driverId,
      'organizationId': organizationId,
      'vehicleName': vehicleName,
      'platNomor': platNomor,
      'tahunPembuatan': tahunPembuatan,
      'odometer': odometer,
      'tipe': tipe,
      'status': status,
      'muatanMax': muatanMax,
      'tipeBensin': tipeBensin,
      'imageUrl': imageUrl,
    };
  }

  Vehicle toEntity() {
    return Vehicle(
      vehicleId: vehicleId,
      driverId: driverId,
      organizationId: organizationId,
      vehicleName: vehicleName,
      platNomor: platNomor,
      tahunPembuatan: tahunPembuatan,
      odometer: odometer,
      tipe: tipe,
      status: status,
      muatanMax: muatanMax,
      tipeBensin: tipeBensin,
      imageUrl: imageUrl,
    );
  }
}
