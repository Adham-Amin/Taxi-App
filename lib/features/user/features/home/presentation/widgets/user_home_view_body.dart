// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taxi_app/core/helper/map_helper.dart';

import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/user/features/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/features/home/data/models/trip_status_enum.dart';
import 'package:taxi_app/features/user/features/home/presentation/manager/cubit/trip_cubit.dart';
import 'package:taxi_app/features/user/features/home/presentation/manager/map_cubit/google_map_cubit.dart';
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
  late TextEditingController _priceController;
  GoogleMapController? _mapController;
  StreamSubscription? _locationSubscription;

  final LocationServices _locationService = LocationServices();

  late CameraPosition initialCameraPosition;

  LocationModel? _currentLocation;
  LocationModel? _destinationLocation;

  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  String status = '';
  String? darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _initLocationStream();
    _priceController = TextEditingController();
    initialCameraPosition = const CameraPosition(
      target: LatLng(27.003337, 29.9530391),
      zoom: 5,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationSubscription?.cancel();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {
        state is TripError
            ? customSnackBar(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.warning,
              )
            : null;
      },
      builder: (context, state) {
        return Stack(children: [_buildMap(), _buildStatusUI(state)]);
      },
    );
  }

  Widget _buildStatusUI(TripState state) {
    if (state is TripSearching) {
      return SearchingDriverOverlay(
        cancelSearching: () {
          _priceController.clear();
          _polylines.clear();
          _markers.clear();
          _initLocationStream();
          context.read<TripCubit>().cancelRide();
        },
      );
    }

    if (state is TripAccepted || state is TripArrived || state is TripOnGoing) {
      final trip = (state as dynamic).trip as TripModel;
      if (trip.status == TripStatus.accepted) {
        _updateDriverMarker(LatLng(trip.driver.lat!, trip.driver.lng!));
      } else {
        _markers.removeWhere((m) => m.markerId.value == 'driver_marker');
      }
      return DriverInfo(trip: trip);
    }

    if (state is TripCompleted) {
      return DoneTrip(
        trip: state.trip,
        onTap: () {
          _priceController.clear();
          _polylines.clear();
          _markers.clear();
          _initLocationStream();
          context.read<TripCubit>().doneRide();
        },
      );
    }

    return _buildIdleUI(state is TripLoading);
  }

  Widget _buildMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      initialCameraPosition: initialCameraPosition,
      markers: _markers,
      polylines: _polylines,
      onMapCreated: (controller) async {
        _mapController = controller;
        if (darkMapStyle != null) {
          // ignore: deprecated_member_use
          await controller.setMapStyle(darkMapStyle);
        }
      },
    );
  }

  Widget _buildIdleUI(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          MapSearchCard(
            currentLocation: (currentLocation) {
              setState(() => _currentLocation = currentLocation);
              return _getCurrentLocation();
            },
            destLocation: (dest) {
              setState(() => _destinationLocation = dest);
              _onDestinationSelected(destination: dest);
            },
          ),
          const Spacer(),

          RequestButton(
            isLoading: isLoading,
            priceController: _priceController,
            onTap: () {
              if (_destinationLocation == null ||
                  _currentLocation == null ||
                  _priceController.text.isEmpty) {
                customSnackBar(
                  context: context,
                  message: 'Please fill all fields',
                  type: AnimatedSnackBarType.warning,
                );
                setState(() {});
                return;
              }

              var formattedDate = DateFormat(
                'yyyy MMM d, hh:mm a',
              ).format(DateTime.now());

              final trip = TripModel(
                id: '',
                destination: _destinationLocation!,
                driver: DriverModel.empty(),
                status: TripStatus.searching,
                pickup: _currentLocation!,
                price: double.tryParse(_priceController.text) ?? 0.0,
                user: Prefs.getUser()!,
                createdAt: formattedDate,
              );

              context.read<TripCubit>().requestRide(trip: trip);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateDriverMarker(LatLng location) async {
    _markers.removeWhere((m) => m.markerId.value == 'driver_marker');

    final marker = Marker(
      markerId: const MarkerId('driver_marker'),
      position: LatLng(location.latitude, location.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    _markers.add(marker);
    setState(() {});
  }

  Future<void> _loadMapStyle() async {
    darkMapStyle = await rootBundle.loadString('assets/json/map_style.json');
  }

  void _initLocationStream() {
    _locationSubscription = _locationService.getLocationStream().listen((
      location,
    ) {
      _updateLocation(
        LocationModel(
          lat: location.latitude!,
          lng: location.longitude!,
          fullAddress: '',
        ),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    _markers.add(
      Marker(
        markerId: const MarkerId('CurrentLocation'),
        position: LatLng(location.lat, location.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    setState(() {});
    _updateLocation(location);
  }

  Future<void> _updateLocation(LocationModel location) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(location.lat, location.lng), zoom: 18),
        ),
      );
    }
    _markers.removeWhere((m) => m.markerId.value == 'myLocation');
    final marker = await MapHelper.buildCurrentMarker(location: location);
    _markers.add(marker);
    setState(() {});
  }

  Future<void> _onDestinationSelected({
    required LocationModel destination,
  }) async {
    if (_currentLocation == null) return;
    final dest = LatLng(destination.lat, destination.lng);
    _markers.add(MapHelper.buildDestinationMarker(destination: dest));
    setState(() {});
    await context.read<MapCubit>().getPolylinePoints(
      origin: LatLng(_currentLocation!.lat, _currentLocation!.lng),
      destination: dest,
    );
    final points = context.read<MapCubit>().polylinePoints;
    _polylines = MapHelper.buildRoutePolylines(points: points);
    setState(() {});
    await MapHelper.fitBounds(
      controller: _mapController!,
      padding: 170,
      points: points,
    );
  }
}
