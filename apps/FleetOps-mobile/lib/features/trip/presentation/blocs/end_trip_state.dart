abstract class EndTripState {}

class EndTripInitial extends EndTripState {}

class EndTripLoading extends EndTripState {}

class EndTripSuccess extends EndTripState {
  final String tripId;

  EndTripSuccess({required this.tripId});
}

class EndTripError extends EndTripState {
  final String message;

  EndTripError({required this.message});
}
