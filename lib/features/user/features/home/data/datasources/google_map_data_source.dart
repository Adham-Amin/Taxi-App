import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/services/api_service.dart';
import 'package:taxi_app/features/user/features/home/data/models/place_response.dart';
import 'package:taxi_app/features/user/features/home/data/models/route_response.dart';

abstract class MapDataSource {
  Future<List<PlaceResponse>> getPlaces({required String query});
  Future<List<LatLng>> getPolylinePoints({
    required LatLng origin,
    required LatLng destination,
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
      endPoint: '/search?q=$query&format=json',
    );

    return List<PlaceResponse>.from(data.map((e) => PlaceResponse.fromJson(e)));
  }

  @override
  Future<List<LatLng>> getPolylinePoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    var data = await _apiService.get(
      baseUrl: 'https://router.project-osrm.org/route/v1/driving',
      endPoint:
          '/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );
    return RouteResponse.fromJson(data['routes'][0]).geometry!.coordinates
        .map((e) => LatLng(e[1].toDouble(), e[0].toDouble()))
        .toList();
  }
}
