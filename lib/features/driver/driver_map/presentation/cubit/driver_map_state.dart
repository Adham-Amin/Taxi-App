part of 'driver_map_cubit.dart';

abstract class DriverMapState {}

class DriverMapInitial extends DriverMapState {}

class DriverMapLoading extends DriverMapState {}

class DriverMapGoingToPickup extends DriverMapState {
  final TripModel trip;
  DriverMapGoingToPickup(this.trip);
}

class DriverMapArrivedAtPickup extends DriverMapState {
  final TripModel trip;
  DriverMapArrivedAtPickup(this.trip);
}

class DriverMapOnTrip extends DriverMapState {
  final TripModel trip;
  DriverMapOnTrip(this.trip);
}

class DriverMapTripCompleted extends DriverMapState {
  final TripModel trip;
  DriverMapTripCompleted(this.trip);
}

class DriverMapTripDone extends DriverMapState {}

class DriverMapError extends DriverMapState {
  final String message;
  DriverMapError(this.message);
}
