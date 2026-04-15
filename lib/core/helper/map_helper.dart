import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/utils/app_assets.dart';

class MapHelper {
  static Future<void> moveToLocation({
    required GoogleMapController controller,
    required LocationModel location,
    double zoom = 18,
  }) async {
    final latLng = LatLng(location.lat, location.lng);

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom),
      ),
    );
  }

  static Future<Marker> buildCurrentMarker({
    required LocationModel location,
  }) async {
    return Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(location.lat, location.lng),
      icon: await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 50)),
        AppAssets.imagesMarker,
      ),
    );
  }

  static Marker buildDestinationMarker({required LatLng destination}) {
    return Marker(
      markerId: const MarkerId('destination'),
      position: destination,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
  }

  static LatLngBounds calculateBounds({required List<LatLng> points}) {
    LatLng northeast = points.first;
    LatLng southwest = points.first;

    for (final point in points) {
      northeast = LatLng(
        max(northeast.latitude, point.latitude),
        max(northeast.longitude, point.longitude),
      );

      southwest = LatLng(
        min(southwest.latitude, point.latitude),
        min(southwest.longitude, point.longitude),
      );
    }

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  static Future<void> fitBounds({
    required GoogleMapController controller,
    required List<LatLng> points,
    double padding = 64,
  }) async {
    if (points.isEmpty) return;

    final bounds = calculateBounds(points: points);

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  static Set<Polyline> buildRoutePolylines({required List<LatLng> points}) {
    return {
      Polyline(
        polylineId: const PolylineId('route_glow'),
        color: const Color(0x5522C55E),
        width: 12,
        points: points,
      ),
      Polyline(
        polylineId: const PolylineId('route'),
        color: const Color(0xFF22C55E),
        width: 5,
        points: points,
      ),
    };
  }
}
