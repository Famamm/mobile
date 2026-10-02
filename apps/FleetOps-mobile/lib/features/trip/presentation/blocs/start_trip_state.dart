abstract class StartTripState {}

class StartTripInitial extends StartTripState {}

class StartTripLoading extends StartTripState {}

class StartTripSuccess extends StartTripState {
  final String tripId;

  StartTripSuccess({required this.tripId});
}

class StartTripError extends StartTripState {
  final String message;

  StartTripError({required this.message});
}
