abstract class CancelTripEvent {}

class CancelTripSubmitted extends CancelTripEvent {
  final int tripId;
  final int driverId;

  CancelTripSubmitted({
    required this.tripId,
    required this.driverId,
  });
}
