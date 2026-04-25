part of 'driver_trips_cubit.dart';

abstract class DriverTripsState {}

class DriverTripsInitial extends DriverTripsState {}

class DriverTripsLoading extends DriverTripsState {}

class DriverTripsLoaded extends DriverTripsState {
  final List<TripEntity> trips;
  DriverTripsLoaded({required this.trips});
}

class DriverTripsError extends DriverTripsState {
  final String message;
  DriverTripsError({required this.message});
}
