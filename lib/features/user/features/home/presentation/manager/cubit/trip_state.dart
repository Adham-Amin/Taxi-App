part of 'trip_cubit.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripSearching extends TripState {}

class TripAccepted extends TripState {
  final TripModel trip;
  TripAccepted(this.trip);
}

class TripArrived extends TripState {
  final TripModel trip;
  TripArrived(this.trip);
}

class TripOnGoing extends TripState {
  final TripModel trip;
  TripOnGoing(this.trip);
}

class TripCompleted extends TripState {
  final TripModel trip;
  TripCompleted(this.trip);
}

class TripDone extends TripState {}

class TripCanceled extends TripState {}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}
