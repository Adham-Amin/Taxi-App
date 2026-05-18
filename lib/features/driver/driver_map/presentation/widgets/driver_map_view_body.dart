import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/helper/map_helper.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/cubit/driver_map_cubit.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/widgets/trip_action_button.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/widgets/trip_done_overlay.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/widgets/user_info_panel.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';

class DriverMapViewBody extends StatefulWidget {
  const DriverMapViewBody({super.key, required this.offer});

  final OfferEntity offer;

  @override
  State<DriverMapViewBody> createState() => _DriverMapViewBodyState();
}

class _DriverMapViewBodyState extends State<DriverMapViewBody> {
  GoogleMapController? _mapController;
  StreamSubscription? _locationSubscription;
  final LocationServices _locationService = LocationServices();

  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String? _darkMapStyle;

  Type? _lastPhaseType;

  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.offer.pickup.lat, widget.offer.pickup.lng),
      zoom: 15,
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
    return BlocConsumer<DriverMapCubit, DriverMapState>(
      listener: (context, state) {
        if (state is DriverMapTripDone) {
          context.go(AppRoutes.driverMain);
        }
        if (state is DriverMapError) {
          customSnackBar(
            context: context,
            message: state.message,
            type: AnimatedSnackBarType.warning,
          );
        }
        if (state.runtimeType != _lastPhaseType) {
          _lastPhaseType = state.runtimeType;
          _onPhaseChanged(state);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            _buildMap(),
            if (state is DriverMapTripCompleted)
              TripDoneOverlay(
                trip: state.trip,
                onDone: () => context.read<DriverMapCubit>().doneRide(),
              )
            else if (state is DriverMapGoingToPickup ||
                state is DriverMapArrivedAtPickup ||
                state is DriverMapOnTrip)
              _buildBottomPanel(state),
            if (state is DriverMapLoading || state is DriverMapInitial)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      style: _darkMapStyle,
      initialCameraPosition: _initialCameraPosition,
      markers: _markers,
      polylines: _polylines,
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }

  Widget _buildBottomPanel(DriverMapState state) {
    final String actionTitle;
    final VoidCallback actionOnTap;
    String? userPhone;

    if (state is DriverMapGoingToPickup) {
      actionTitle = 'Arrived';
      actionOnTap = () => context.read<DriverMapCubit>().arrivedAtPickup();
      userPhone = state.trip.user.phone;
    } else if (state is DriverMapArrivedAtPickup) {
      actionTitle = 'Start Trip';
      actionOnTap = () => context.read<DriverMapCubit>().startRide();
      userPhone = state.trip.user.phone;
    } else if (state is DriverMapOnTrip) {
      actionTitle = 'End Trip';
      actionOnTap = () => context.read<DriverMapCubit>().endRide();
      userPhone = state.trip.user.phone;
    } else {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 32.h,
      left: 24.w,
      right: 24.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserInfoPanel(offer: widget.offer, userPhone: userPhone),
          16.hs,
          TripActionButton(title: actionTitle, onTap: actionOnTap),
        ],
      ),
    );
  }

  void _onPhaseChanged(DriverMapState state) {
    if (state is DriverMapGoingToPickup) {
      _setupGoingToPickupPhase(state);
    } else if (state is DriverMapArrivedAtPickup) {
      _setupArrivedAtPickupPhase(state);
    } else if (state is DriverMapOnTrip) {
      _setupOnTripPhase(state);
    } else if (state is DriverMapTripCompleted) {
      _locationSubscription?.cancel();
    }
  }

  Future<void> _setupGoingToPickupPhase(DriverMapGoingToPickup state) async {
    _markers.clear();
    _polylines.clear();

    final pickupLatLng = LatLng(
      widget.offer.pickup.lat,
      widget.offer.pickup.lng,
    );
    _markers.add(MapHelper.buildPickupMarker(pickup: pickupLatLng));

    _startDriverLocationStream();

    try {
      final driverLocation = await _locationService.getCurrentLocation();
      final driverLatLng = LatLng(driverLocation.lat, driverLocation.lng);

      if (!mounted) return;
      await context.read<MapCubit>().getPolylinePoints(
            origin: driverLatLng,
            destination: pickupLatLng,
          );

      if (!mounted) return;
      final points = context.read<MapCubit>().polylinePoints;
      _polylines = MapHelper.buildRoutePolylines(points: points);
      setState(() {});

      if (_mapController != null && points.isNotEmpty) {
        await MapHelper.fitBounds(
          controller: _mapController!,
          points: points,
          padding: 80,
        );
      }
    } catch (_) {}
  }

  Future<void> _setupArrivedAtPickupPhase(
      DriverMapArrivedAtPickup state) async {
    _locationSubscription?.cancel();
    _markers.clear();
    _polylines.clear();

    final pickupLatLng = LatLng(
      widget.offer.pickup.lat,
      widget.offer.pickup.lng,
    );
    final destLatLng = LatLng(
      widget.offer.destination.lat,
      widget.offer.destination.lng,
    );

    _markers.add(MapHelper.buildPickupMarker(pickup: pickupLatLng));
    _markers.add(MapHelper.buildDestinationMarker(destination: destLatLng));
    setState(() {});

    try {
      if (!mounted) return;
      await context.read<MapCubit>().getPolylinePoints(
            origin: pickupLatLng,
            destination: destLatLng,
          );

      if (!mounted) return;
      final points = context.read<MapCubit>().polylinePoints;
      _polylines = MapHelper.buildRoutePolylines(points: points);
      setState(() {});

      if (_mapController != null && points.isNotEmpty) {
        await MapHelper.fitBounds(
          controller: _mapController!,
          points: points,
          padding: 80,
        );
      }
    } catch (_) {}
  }

  Future<void> _setupOnTripPhase(DriverMapOnTrip state) async {
    _markers.clear();
    _polylines.clear();

    final destLatLng = LatLng(
      widget.offer.destination.lat,
      widget.offer.destination.lng,
    );
    _markers.add(MapHelper.buildDestinationMarker(destination: destLatLng));

    _startDriverLocationStream();

    try {
      final driverLocation = await _locationService.getCurrentLocation();
      final driverLatLng = LatLng(driverLocation.lat, driverLocation.lng);

      if (!mounted) return;
      await context.read<MapCubit>().getPolylinePoints(
            origin: driverLatLng,
            destination: destLatLng,
          );

      if (!mounted) return;
      final points = context.read<MapCubit>().polylinePoints;
      _polylines = MapHelper.buildRoutePolylines(points: points);
      setState(() {});

      if (_mapController != null && points.isNotEmpty) {
        await MapHelper.fitBounds(
          controller: _mapController!,
          points: points,
          padding: 80,
        );
      }
    } catch (_) {}
  }

  void _startDriverLocationStream() {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.getLocationStream().listen(
      (location) async {
        if (location.latitude == null || location.longitude == null) return;

        final loc = LocationModel(
          lat: location.latitude!,
          lng: location.longitude!,
          fullAddress: '',
        );

        _markers.removeWhere((m) => m.markerId.value == 'myLocation');
        final marker = await MapHelper.buildCurrentMarker(location: loc);
        _markers.add(marker);
        if (mounted) setState(() {});
      },
    );
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/json/map_style.json');
  }
}
