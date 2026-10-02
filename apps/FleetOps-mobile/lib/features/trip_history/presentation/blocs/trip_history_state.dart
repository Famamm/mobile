import '../../domain/entities/trip_history.dart';

abstract class TripHistoryState {}

class TripHistoryInitial extends TripHistoryState {}

class TripHistoryLoading extends TripHistoryState {}

class TripHistoryLoaded extends TripHistoryState {
  final List<TripHistory> trips;
  TripHistoryLoaded(this.trips);
}

class TripHistoryError extends TripHistoryState {
  final String message;
  TripHistoryError(this.message);
}
