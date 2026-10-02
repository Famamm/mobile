abstract class StartTripEvent {}

class StartTripSubmitted extends StartTripEvent {
  final int driverId;
  final int vehicleId;
  final String titikAwal;
  final String titikAkhir;
  final int odometerAwal;
  final double? kordAwalLatitude;
  final double? kordAwalLongitude;

  StartTripSubmitted({
    required this.driverId,
    required this.vehicleId,
    required this.titikAwal,
    required this.titikAkhir,
    required this.odometerAwal,
    this.kordAwalLatitude,
    this.kordAwalLongitude,
  });
}
