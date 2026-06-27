import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/services/api_service.dart';
import 'package:taxi_app/core/utils/egypt_geo.dart';
import 'package:taxi_app/features/user/home/data/models/place_response.dart';
import 'package:taxi_app/features/user/home/data/models/route_response.dart';
import 'package:taxi_app/features/user/home/domain/entities/route_info_entity.dart';

abstract class MapDataSource {
  Future<List<PlaceResponse>> getPlaces({required String query});
  Future<List<LatLng>> getPolylinePoints({
    required LatLng origin,
    required LatLng destination,
  });

  /// Like [getPolylinePoints] but also returns the trip distance (km) and
  /// duration (minutes) reported by the routing service.
  Future<RouteInfoEntity> getRoute({
    required LatLng origin,
    required LatLng destination,
  });
  Future<PlaceResponse> reverseGeocode({
    required double lat,
    required double lng,
  });
}

class MapDataSourceImpl implements MapDataSource {
  final ApiService _apiService;

  MapDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<PlaceResponse>> getPlaces({required String query}) async {
    var data = await _apiService.get(
      baseUrl: 'https://nominatim.openstreetmap.org',
      endPoint:
          '/search?q=$query&format=json${EgyptGeo.nominatimQuerySuffix}',
    );

    return List<PlaceResponse>.from(data.map((e) => PlaceResponse.fromJson(e)));
  }

  @override
  Future<List<LatLng>> getPolylinePoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final route = await getRoute(origin: origin, destination: destination);
    return route.points;
  }

  @override
  Future<RouteInfoEntity> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    var data = await _apiService.get(
      baseUrl: 'https://router.project-osrm.org/route/v1/driving',
      endPoint:
          '/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );
    final route = RouteResponse.fromJson(data['routes'][0]);
    final points = route.geometry!.coordinates
        .map((e) => LatLng(e[1].toDouble(), e[0].toDouble()))
        .toList();
    return RouteInfoEntity(
      points: points,
      distanceKm: (route.distance ?? 0) / 1000,
      durationMin: (route.duration ?? 0) / 60,
    );
  }

  @override
  Future<PlaceResponse> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    var data = await _apiService.get(
      baseUrl: 'https://nominatim.openstreetmap.org',
      endPoint: '/reverse?lat=$lat&lon=$lng&format=json',
    );

    return PlaceResponse.fromJson(data);
  }
}
