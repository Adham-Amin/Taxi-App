part of 'trips_histroy_cubit.dart';

abstract class TripsHistoryState {}

class TripsInitial extends TripsHistoryState {}

class TripsHistoryLoading extends TripsHistoryState {}

class TripsHistoryLoaded extends TripsHistoryState {
  final List<TripEntity> trips;
  TripsHistoryLoaded({required this.trips});
}

class TripsHistoryError extends TripsHistoryState {
  final String message;
  TripsHistoryError({required this.message});
}
