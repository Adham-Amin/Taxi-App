part of 'trips_cubit.dart';

abstract class TripsState {}

class TripsInitial extends TripsState {}

class TripsLoading extends TripsState {}

class TripsLoaded extends TripsState {
  final List<TripEntity> trips;
  TripsLoaded({required this.trips});
}

class TripsError extends TripsState {
  final String message;
  TripsError({required this.message});
}
