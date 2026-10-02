abstract class CancelTripState {}

class CancelTripInitial extends CancelTripState {}

class CancelTripLoading extends CancelTripState {}

class CancelTripSuccess extends CancelTripState {
  final String tripId;

  CancelTripSuccess({required this.tripId});
}

class CancelTripError extends CancelTripState {
  final String message;

  CancelTripError({required this.message});
}
