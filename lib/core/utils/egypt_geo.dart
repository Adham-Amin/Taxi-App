import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Geographic constants and helpers that constrain the app to Egypt.
///
/// Egypt is approximated with an axis-aligned bounding box that covers the
/// mainland plus the Sinai peninsula. The containment check is purely offline
/// (no network call) so it is cheap and deterministic.
abstract class EgyptGeo {
  EgyptGeo._();

  // Bounding box edges.
  static const double minLat = 22.0;
  static const double maxLat = 31.9;
  static const double minLng = 24.7;
  static const double maxLng = 37.0;

  /// Country centroid used as the camera fallback when the user's location is
  /// not yet available.
  static const LatLng center = LatLng(27.003337, 29.9530391);

  /// Camera bounds for [CameraTargetBounds].
  static final LatLngBounds bounds = LatLngBounds(
    southwest: const LatLng(minLat, minLng),
    northeast: const LatLng(maxLat, maxLng),
  );

  /// `viewbox` value for Nominatim (`left,top,right,bottom` => `minLng,maxLat,maxLng,minLat`).
  static const String nominatimViewbox = '$minLng,$maxLat,$maxLng,$minLat';

  /// Query suffix that restricts Nominatim results to Egypt only.
  static const String nominatimQuerySuffix =
      '&countrycodes=eg&viewbox=$nominatimViewbox&bounded=1';

  /// Whether the given coordinate falls inside the Egypt bounding box.
  static bool isInside(double lat, double lng) {
    return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
  }
}
