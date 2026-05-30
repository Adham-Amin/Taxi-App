import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

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

  static Marker buildPickupMarker({required LatLng pickup}) {
    return Marker(
      markerId: const MarkerId('pickup'),
      position: pickup,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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

  static Set<Polyline> buildInitialPolylines(List<LatLng> points) {
    return {
      Polyline(
        polylineId: const PolylineId('remaining'),
        points: points,
        color: AppColors.lightGreen,
        width: 6,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  // ignore: deprecated_member_use
  static ({Set<Polyline> polylines, int passedIndex}) buildProgressivePolylines({
    required List<LatLng> fullRoute,
    required int currentPassedIndex,
    required LatLng driverPos,
  }) {
    if (fullRoute.isEmpty) {
      return (polylines: <Polyline>{}, passedIndex: currentPassedIndex);
    }

    double minDist = double.infinity;
    int closestIdx = currentPassedIndex;
    for (int i = currentPassedIndex; i < fullRoute.length; i++) {
      final d = haversineDistance(driverPos, fullRoute[i]);
      if (d < minDist) {
        minDist = d;
        closestIdx = i;
      } else {
        break;
      }
    }

    final passedPoints = fullRoute.sublist(0, closestIdx + 1);
    final remainingPoints = fullRoute.sublist(closestIdx);

    final polylines = <Polyline>{
      if (passedPoints.length >= 2)
        Polyline(
          polylineId: const PolylineId('passed'),
          points: passedPoints,
          // ignore: deprecated_member_use
          color: AppColors.slateGray.withOpacity(0.45),
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      if (remainingPoints.length >= 2)
        Polyline(
          polylineId: const PolylineId('remaining'),
          points: remainingPoints,
          color: AppColors.lightGreen,
          width: 6,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
    };

    return (polylines: polylines, passedIndex: closestIdx);
  }

  static double haversineDistance(LatLng a, LatLng b) {
    const R = 6371000.0;
    final dLat = (b.latitude - a.latitude) * 3.14159 / 180;
    final dLng = (b.longitude - a.longitude) * 3.14159 / 180;
    final sinDLat = dLat / 2;
    final sinDLng = dLng / 2;
    final c = sinDLat * sinDLat + sinDLng * sinDLng;
    return R * 2 * (c < 1 ? c : 1);
  }

  static Future<void> smoothCameraFollow(
    GoogleMapController controller,
    LatLng target, {
    double zoom = 17.0,
    double bearing = 0,
    double tilt = 0,
  }) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: zoom,
          bearing: bearing,
          tilt: tilt,
        ),
      ),
    );
  }

  static Future<void> applyMapStyle(
    GoogleMapController controller,
    bool isLight,
  ) async {
    if (isLight) {
      // ignore: deprecated_member_use
      await controller.setMapStyle(null);
    } else {
      final style = await rootBundle.loadString('assets/json/map_style.json');
      // ignore: deprecated_member_use
      await controller.setMapStyle(style);
    }
  }

  static Future<void> loadMapStyle() async {
    await rootBundle.loadString('assets/json/map_style.json');
  }
}
