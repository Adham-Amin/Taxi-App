part of 'google_map_cubit.dart';

abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class PlacesLoading extends GoogleMapState {}

class PlacesLoaded extends GoogleMapState {}

class PolylineLoading extends GoogleMapState {}

class PolylineLoaded extends GoogleMapState {}

class GoogleMapError extends GoogleMapState {
  final String failure;
  GoogleMapError({required this.failure});
}
