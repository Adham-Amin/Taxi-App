part of 'google_map_cubit.dart';

abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class CurrentLocationLoading extends GoogleMapState {}

class CurrentLocationLoaded extends GoogleMapState {
  final LocationModel location;
  CurrentLocationLoaded({required this.location});
}

class PlacesLoading extends GoogleMapState {}

class PlacesLoaded extends GoogleMapState {}

class PolylineLoading extends GoogleMapState {}

class PolylineLoaded extends GoogleMapState {}

class AddressLoading extends GoogleMapState {}

class AddressLoaded extends GoogleMapState {
  final LocationModel location;
  AddressLoaded({required this.location});
}

class GoogleMapError extends GoogleMapState {
  final String failure;
  GoogleMapError({required this.failure});
}
