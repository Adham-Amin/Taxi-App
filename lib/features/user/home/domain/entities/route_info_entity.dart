import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A computed route between two points: the drawable polyline plus the trip
/// distance and duration used for the suggested fare and ETA display.
class RouteInfoEntity {
  final List<LatLng> points;
  final double distanceKm;
  final double durationMin;

  RouteInfoEntity({
    required this.points,
    required this.distanceKm,
    required this.durationMin,
  });

  RouteInfoEntity.empty()
    : points = const [],
      distanceKm = 0,
      durationMin = 0;
}
