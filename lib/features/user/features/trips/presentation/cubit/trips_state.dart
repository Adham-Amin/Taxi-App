part of 'trips_cubit.dart';

abstract class TripsState {}

class TripsInitial extends TripsState {}

class TripsLoading extends TripsState {}

class TripsLoaded extends TripsState {}

class TripsError extends TripsState {
  final String message;
  TripsError({required this.message});
}
