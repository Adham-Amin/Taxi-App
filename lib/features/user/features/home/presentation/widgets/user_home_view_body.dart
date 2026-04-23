// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/helper/map_helper.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/theme_cubit/theme_cubit.dart';
import 'package:taxi_app/core/theme_cubit/theme_state.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
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
    final isLight = Theme.of(context).brightness == Brightness.light;
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
        return Stack(children: [_buildMap(isLight), _buildStatusUI(state)]);
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

  Widget _buildMap(bool isLight) {
    return BlocListener<ThemeCubit, ThemeState>(
      listener: (context, state) {
        final isLight = state.themeMode == ThemeMode.light;
        _applyMapStyle(isLight);
      },
      child: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        initialCameraPosition: initialCameraPosition,
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) async {
          _mapController = controller;
          _applyMapStyle(isLight);
        },
      ),
    );
  }

  Widget _buildIdleUI(bool isLoading) {
    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.05,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.25, 0.65, 0.85],
      builder: (context, scrollController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.dark.withOpacity(0.6),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  16.hs,
                  Text(
                    "${LocaleKeys.start_your_ride.tr()} 🚖",
                    style: AppStyles.textExtraBold24.copyWith(
                      color: AppColors.offWhite,
                    ),
                  ),
                  4.hs,
                  Text(
                    LocaleKeys.select_pickup_and_destination.tr(),
                    style: AppStyles.textMedium14.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  16.hs,
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * 10),
                          child: child,
                        ),
                      );
                    },
                    child: MapSearchCard(
                      currentLocation: (currentLocation) {
                        setState(() => _currentLocation = currentLocation);
                        _onPickupSelected(pickup: currentLocation);
                      },
                      destLocation: (dest) {
                        setState(() => _destinationLocation = dest);
                        _onDestinationSelected(destination: dest);
                      },
                    ),
                  ),
                  16.hs,
                  RequestButton(
                    isLoading: isLoading,
                    priceController: _priceController,
                    onTap: _onRequestRide,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onRequestRide() {
    if (_destinationLocation == null ||
        _currentLocation == null ||
        _priceController.text.isEmpty) {
      customSnackBar(
        context: context,
        message: LocaleKeys.please_fill_all_fields.tr(),
        type: AnimatedSnackBarType.warning,
      );
      return;
    }
    setState(() {});

    final trip = TripModel(
      id: '',
      driverId: '',
      userId: Prefs.getUser()!.id!,
      destination: _destinationLocation!,
      driver: DriverModel.empty(),
      status: TripStatus.searching,
      pickup: _currentLocation!,
      price: double.tryParse(_priceController.text) ?? 0.0,
      user: Prefs.getUser()!,
      createdAt: DateFormat('yyyy MMM d, hh:mm a').format(DateTime.now()),
    );

    context.read<TripCubit>().requestRide(trip: trip);
  }

  Future<void> _applyMapStyle(bool isLight) async {
    if (_mapController == null) return;

    if (isLight) {
      await _mapController!.setMapStyle(null);
    } else {
      await _mapController!.setMapStyle(darkMapStyle);
    }
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

  Future<void> _onPickupSelected({required LocationModel pickup}) async {
    _currentLocation = pickup;
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pickup.lat, pickup.lng), zoom: 18),
      ),
    );
    final pickUP = LatLng(pickup.lat, pickup.lng);
    _markers.add(MapHelper.buildPickupMarker(pickup: pickUP));
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
