abstract class AddVehicleEvent {}

class AddVehicleSubmitted extends AddVehicleEvent {
  final int organizationId;
  final String vehicleName;
  final String platNomor;
  final int tahunPembuatan;
  final int odometer;
  final String tipe;
  final String status;
  final int muatanMax;
  final int tipeBensin;
  final String? imagePath;

  AddVehicleSubmitted({
    required this.organizationId,
    required this.vehicleName,
    required this.platNomor,
    required this.tahunPembuatan,
    required this.odometer,
    required this.tipe,
    required this.status,
    required this.muatanMax,
    required this.tipeBensin,
    this.imagePath,
  });
}
