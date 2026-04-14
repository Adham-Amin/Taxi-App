import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/features/user/features/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/features/home/presentation/cubit/google_map_cubit.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/custom_drawer_button.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/done_trip.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/driver_info.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/map_search_card.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/request_button.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/searching_driver_overlay.dart';

class UserHomeViewBody extends StatefulWidget {
  const UserHomeViewBody({super.key});

  @override
  State<UserHomeViewBody> createState() => _UserHomeViewBodyState();
}

class _UserHomeViewBodyState extends State<UserHomeViewBody> {
  GoogleMapController? _mapController;
  StreamSubscription<LocationData>? _locationSubscription;
  final LocationServices _locationService = LocationServices();
  late CameraPosition initialCameraPosition;

  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  var stauts = 'Done';

  String? darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    getLocationStream();
    initialCameraPosition = const CameraPosition(
      target: LatLng(27.003337, 29.9530391),
      zoom: 5,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          initialCameraPosition: initialCameraPosition,
          markers: _markers,
          polylines: _polylines,
          onMapCreated: (controller) {
            _mapController = controller;
            if (darkMapStyle != null) {
              _mapController?.setMapStyle(darkMapStyle);
            }
          },
        ),
        stauts == 'Done'
            ? DoneTrip(
                onTap: () {
                  setState(() {
                    stauts = 'Cancel';
                  });
                },
              )
            : stauts == 'Accepted' || stauts == 'Arrived'
            ? DriverInfo(stauts: stauts)
            : stauts == 'Search'
            ? SearchingDriverOverlay(
                cancelSearching: () {
                  setState(() {
                    stauts = 'Cancel';
                  });
                },
              )
            : Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 32,
                  top: 80,
                ),
                child: Column(
                  children: [
                    MapSearchCard(
                      currentLocation: (_) {
                        getCurrentLocation();
                      },
                      destLocation: _onDestinationSelected,
                    ),
                    Spacer(),
                    RequestButton(
                      onTap: () {
                        setState(() {
                          stauts = 'Search';
                        });
                        Timer(const Duration(seconds: 5), () {
                          setState(() {
                            stauts = 'Accepted';
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
        CustomDrawerButton(),
      ],
    );
  }

  Future<void> _loadMapStyle() async {
    darkMapStyle = await rootBundle.loadString('assets/json/map_style.json');
  }

  void getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    Marker marker = Marker(
      markerId: const MarkerId('CurrentLocation'),
      position: LatLng(
        location.locationLat.toDouble(),
        location.locationLng.toDouble(),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    _markers.add(marker);
    setState(() {});
    _updateCurrentLocation(location);
  }

  void getLocationStream() {
    _locationSubscription = _locationService.getLocationStream().listen((
      location,
    ) {
      _updateCurrentLocation(
        LocationModel(
          locationLat: location.latitude!,
          locationLng: location.longitude!,
          fullAddress: '',
        ),
      );
    });
  }

  void _updateCurrentLocation(LocationModel location) async {
    final LatLng newLocation = LatLng(
      location.locationLat.toDouble(),
      location.locationLng.toDouble(),
    );

    _currentLocation = newLocation;

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newLocation, zoom: 18),
      ),
    );

    _markers.removeWhere((m) => m.markerId.value == 'myLocation');

    _markers.add(
      Marker(
        markerId: const MarkerId('myLocation'),
        position: newLocation,
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: const Size(50, 50)),
          AppAssets.imagesMarker,
        ),
      ),
    );

    setState(() {});
  }

  Future<void> _onDestinationSelected(PlaceEntity destination) async {
    if (_currentLocation == null) return;

    final LatLng dest = LatLng(
      destination.lat.toDouble(),
      destination.lon.toDouble(),
    );

    _addDestinationMarker(dest);

    await context.read<GoogleMapCubit>().getPolylinePoints(
      origin: _currentLocation!,
      destination: dest,
    );

    _drawPolyline();
    _moveCameraToBounds();
  }

  void _addDestinationMarker(LatLng destination) {
    _markers.removeWhere((m) => m.markerId.value == 'destination');

    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    setState(() {});
  }

  void _drawPolyline() {
    final points = context.read<GoogleMapCubit>().polylinePoints;

    _polylines.addAll([
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
    ]);

    setState(() {});
  }

  void _moveCameraToBounds() {
    final points = context.read<GoogleMapCubit>().polylinePoints;
    if (points.isEmpty) return;

    LatLng northeast = LatLng(points[0].latitude, points[0].longitude);
    LatLng southwest = LatLng(points[0].latitude, points[0].longitude);

    for (var point in points) {
      northeast = LatLng(
        max(northeast.latitude, point.latitude),
        max(northeast.longitude, point.longitude),
      );

      southwest = LatLng(
        min(southwest.latitude, point.latitude),
        min(southwest.longitude, point.longitude),
      );
    }

    final bounds = LatLngBounds(northeast: northeast, southwest: southwest);

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
  }
}
