import 'package:geocoding/geocoding.dart' hide Location;
import 'package:location/location.dart';
import 'package:taxi_app/core/models/location_model.dart';

class LocationServices {
  final Location _location = Location();

  Future<void> _ensureInitialized() async {
    bool serviceEnabled = await _location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service disabled');
      }
    }

    PermissionStatus permission = await _location.hasPermission();

    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();

      if (permission != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == PermissionStatus.deniedForever) {
      throw Exception('Location permission permanently denied');
    }
  }

  Future<LocationModel> getCurrentLocation() async {
    await _ensureInitialized();
    var position = await _location.getLocation();

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude!,
      position.longitude!,
    );
    var place = placemarks[0];
    return LocationModel(
      locationLat: position.latitude!,
      locationLng: position.longitude!,
      fullAddress: '${place.locality}, ${place.country}',
    );
  }

  Stream<LocationData> getLocationStream() async* {
    await _ensureInitialized();

    _location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );

    yield* _location.onLocationChanged;
  }
}
