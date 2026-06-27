import 'dart:async';
import 'dart:ui';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/helper/animated_driver_marker.dart';
import 'package:taxi_app/core/helper/map_helper.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/theme_cubit/theme_cubit.dart';
import 'package:taxi_app/core/theme_cubit/theme_state.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/utils/egypt_geo.dart';
import 'package:taxi_app/core/widgets/animated_wrappers.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/premium_snack_bar.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/user/home/data/models/ride_model.dart';
import 'package:taxi_app/features/user/home/data/models/trip_status_enum.dart';
import 'package:taxi_app/features/user/home/presentation/manager/cubit/trip_cubit.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/done_trip.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/driver_info.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/map_search_card.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/request_button.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/searching_driver_overlay.dart';

class UserHomeViewBody extends StatefulWidget {
  const UserHomeViewBody({super.key});

  @override
  State<UserHomeViewBody> createState() => _UserHomeViewBodyState();
}

class _UserHomeViewBodyState extends State<UserHomeViewBody>
    with TickerProviderStateMixin {
  late TextEditingController _priceController;
  GoogleMapController? _mapController;
  StreamSubscription? _locationSubscription;

  final LocationServices _locationService = LocationServices();

  late CameraPosition initialCameraPosition;

  LocationModel? _currentLocation;
  LocationModel? _destinationLocation;

  /// The camera auto-centers on the user only once (on open / first GPS fix);
  /// afterwards the user is free to pan without being yanked back.
  bool _hasCentered = false;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _fullRoutePoints = [];
  int _passedPointIndex = 0;

  String? darkMapStyle;

  LatLng? _driverPosition;
  double _driverBearing = 0;
  Timer? _markerAnimationTimer;
  AnimationController? _markerAnimController;
  Animation<double>? _markerAnim;
  LatLng? _markerAnimStart;
  LatLng? _markerAnimEnd;

  late AnimationController _sheetAnimController;
  late Animation<double> _sheetFadeAnim;

  @override
  void initState() {
    super.initState();
    MapHelper.loadMapStyle();
    _initLocationStream();
    _priceController = TextEditingController();
    initialCameraPosition = const CameraPosition(
      target: EgyptGeo.center,
      zoom: 5,
    );

    _sheetAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _sheetFadeAnim = CurvedAnimation(
      parent: _sheetAnimController,
      curve: Curves.easeOutCubic,
    );
    _sheetAnimController.forward();

    _markerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _markerAnim = CurvedAnimation(
      parent: _markerAnimController!,
      curve: Curves.easeInOut,
    );
    _markerAnimController!.addListener(_onMarkerAnimTick);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationSubscription?.cancel();
    _priceController.dispose();
    _sheetAnimController.dispose();
    _markerAnimController?.dispose();
    _markerAnimationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {
        if (state is TripError) {
          customSnackBar(
            context: context,
            message: state.message,
            type: AnimatedSnackBarType.warning,
          );
        } else if (state is TripAccepted) {
          _onTripAccepted(state.trip);
        } else if (state is TripArrived) {
          _onDriverArrived(state.trip);
          PremiumSnackBar.show(
            context,
            icon: Icons.location_on_rounded,
            message: 'Your driver has arrived!',
            color: const Color(0xFF2196F3),
          );
        } else if (state is TripOnGoing) {
          _onTripOnGoing(state.trip);
        }
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
          _clearTripState();
          context.read<TripCubit>().cancelRide();
        },
      );
    }

    if (state is TripAccepted || state is TripArrived || state is TripOnGoing) {
      final trip = (state as dynamic).trip as TripModel;
      return Positioned(
        bottom: 24,
        left: 16,
        right: 16,
        child: AnimatedSlideIn(child: DriverInfo(trip: trip)),
      );
    }

    if (state is TripCompleted || state is TripDone) {
      final trip = (state as dynamic).trip as TripModel;
      return AnimatedSlideIn(
        child: DoneTrip(
          trip: trip,
          onTap: () {
            _clearTripState();
            context.read<TripCubit>().doneRide();
          },
        ),
      );
    }

    return _buildIdleUI(state is TripLoading);
  }

  Widget _buildMap(bool isLight) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ThemeCubit, ThemeState>(
          listener: (context, state) {
            if (_mapController != null) {
              MapHelper.applyMapStyle(
                _mapController!,
                state.themeMode == ThemeMode.light,
              );
            }
          },
        ),
        // Surfaces location/Egypt-validation failures from the pickup icon.
        BlocListener<MapCubit, GoogleMapState>(
          listenWhen: (_, current) => current is GoogleMapError,
          listener: (context, state) {
            if (state is GoogleMapError) {
              customSnackBar(
                context: context,
                message: state.failure,
                type: AnimatedSnackBarType.warning,
              );
            }
          },
        ),
      ],
      child: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: false,
        cameraTargetBounds: CameraTargetBounds(EgyptGeo.bounds),
        initialCameraPosition: initialCameraPosition,
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) async {
          _mapController = controller;
          MapHelper.applyMapStyle(controller, isLight);
        },
      ),
    );
  }

  Widget _buildIdleUI(bool isLoading) {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.04,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.40, 0.70, 0.88],
      builder: (context, scrollController) {
        return FadeTransition(
          opacity: _sheetFadeAnim,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.dark.withValues(alpha: 0.82),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.lightGreen.withValues(alpha: 0.20),
                      width: 1.5,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.slateGray.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Greeting with live time dot
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreen,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightGreen.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                8.ws,
                                Text(
                                  LocaleKeys.start_your_ride.tr(),
                                  style: AppStyles.textBold24.copyWith(
                                    color: AppColors.offWhite,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            6.hs,
                            Text(
                              LocaleKeys.select_pickup_and_destination.tr(),
                              style: AppStyles.textRegular14.copyWith(
                                color: AppColors.mutedSlateGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.hs,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.grey.withValues(alpha: 0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      20.hs,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 16),
                              child: child,
                            ),
                          ),
                          child: MapSearchCard(
                            currentLocation: (loc) {
                              setState(() => _currentLocation = loc);
                              _onPickupSelected(pickup: loc);
                            },
                            destLocation: (dest) {
                              setState(() => _destinationLocation = dest);
                              _onDestinationSelected(destination: dest);
                            },
                          ),
                        ),
                      ),
                      16.hs,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: RequestButton(
                          isLoading: isLoading,
                          priceController: _priceController,
                          onTap: _onRequestRide,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTripAccepted(TripModel trip) {
    if (trip.driver.lat == null || trip.driver.lng == null) return;
    _driverPosition = LatLng(trip.driver.lat!, trip.driver.lng!);
    _updateDriverMarkerSmooth(_driverPosition!);
  }

  void _onDriverArrived(TripModel trip) {
    if (trip.driver.lat != null && trip.driver.lng != null) {
      final pos = LatLng(trip.driver.lat!, trip.driver.lng!);
      _updateDriverMarkerSmooth(pos);
    }
  }

  void _onTripOnGoing(TripModel trip) {
    if (trip.driver.lat == null || trip.driver.lng == null) return;
    final newPos = LatLng(trip.driver.lat!, trip.driver.lng!);

    if (_driverPosition != null) {
      _driverBearing = calculateBearing(_driverPosition!, newPos);
      _animateMarkerMovement(_driverPosition!, newPos);
      _updateProgressivePolyline(newPos);
    }

    _driverPosition = newPos;
    if (_mapController != null) {
      MapHelper.smoothCameraFollow(
        _mapController!,
        newPos,
        zoom: 17.5,
        bearing: _driverBearing,
      );
    }
  }

  void _animateMarkerMovement(LatLng start, LatLng end) {
    _markerAnimStart = start;
    _markerAnimEnd = end;
    _markerAnimController!
      ..reset()
      ..forward();
  }

  void _onMarkerAnimTick() async {
    if (_markerAnimStart == null || _markerAnimEnd == null) return;
    final t = _markerAnim!.value;
    final interpolated = lerpLatLng(_markerAnimStart!, _markerAnimEnd!, t);
    await _updateDriverMarkerSmooth(interpolated);
  }

  Future<void> _updateDriverMarkerSmooth(LatLng position) async {
    final icon = await AnimatedDriverMarker.build(
      bearingDegrees: _driverBearing,
      color: AppColors.lightGreen,
      size: 88,
    );

    _markers.removeWhere((m) => m.markerId.value == 'driver_marker');
    _markers.add(
      Marker(
        markerId: const MarkerId('driver_marker'),
        position: position,
        icon: icon,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: 0,
        zIndexInt: 2,
      ),
    );

    if (mounted) setState(() {});
  }

  void _updateProgressivePolyline(LatLng driverPos) {
    if (_fullRoutePoints.isEmpty) return;

    final result = MapHelper.buildProgressivePolylines(
      fullRoute: _fullRoutePoints,
      currentPassedIndex: _passedPointIndex,
      driverPos: driverPos,
    );
    _passedPointIndex = result.passedIndex;
    _polylines = result.polylines;

    if (mounted) setState(() {});
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

  void _initLocationStream() {
    _locationSubscription?.cancel();
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
    if (_mapController == null) return;
    // Center the camera only on the first GPS fix (on open); afterwards keep
    // the live marker in sync without yanking the camera back from a user pan.
    if (!_hasCentered) {
      _hasCentered = true;
      await MapHelper.smoothCameraFollow(
        _mapController!,
        LatLng(location.lat, location.lng),
        zoom: 18,
      );
    }
    final marker = await MapHelper.buildCurrentMarker(location: location);
    if (mounted) {
      setState(() {
        _markers = {
          ..._markers.where((m) => m.markerId.value != 'myLocation'),
          marker,
        };
      });
    }
  }

  Future<void> _onPickupSelected({required LocationModel pickup}) async {
    if (!EgyptGeo.isInside(pickup.lat, pickup.lng)) {
      _showOutsideEgypt();
      return;
    }
    _currentLocation = pickup;
    if (_mapController != null) {
      await MapHelper.smoothCameraFollow(
        _mapController!,
        LatLng(pickup.lat, pickup.lng),
        zoom: 17,
      );
    }
    if (mounted) {
      setState(() {
        _markers = {
          ..._markers.where((m) => m.markerId.value != 'pickup'),
          MapHelper.buildPickupMarker(pickup: LatLng(pickup.lat, pickup.lng)),
        };
      });
    }
  }

  Future<void> _onDestinationSelected({
    required LocationModel destination,
  }) async {
    if (!EgyptGeo.isInside(destination.lat, destination.lng)) {
      _showOutsideEgypt();
      return;
    }
    if (_currentLocation == null) return;

    final dest = LatLng(destination.lat, destination.lng);
    if (mounted) {
      setState(() {
        _markers = {
          ..._markers.where((m) => m.markerId.value != 'destination'),
          MapHelper.buildDestinationMarker(destination: dest),
        };
        _polylines = {};
      });
    }

    await context.read<MapCubit>().getPolylinePoints(
      origin: LatLng(_currentLocation!.lat, _currentLocation!.lng),
      destination: dest,
    );

    // ignore: use_build_context_synchronously
    _fullRoutePoints = context.read<MapCubit>().polylinePoints;
    _passedPointIndex = 0;

    _polylines = MapHelper.buildInitialPolylines(_fullRoutePoints);

    if (mounted) setState(() {});

    if (_mapController != null && _fullRoutePoints.isNotEmpty) {
      await MapHelper.fitBounds(
        controller: _mapController!,
        padding: 80,
        points: _fullRoutePoints,
      );
    }
  }

  void _showOutsideEgypt() {
    customSnackBar(
      context: context,
      message: LocaleKeys.location_outside_egypt.tr(),
      type: AnimatedSnackBarType.warning,
    );
  }

  void _clearTripState() {
    _priceController.clear();
    setState(() {
      _markers = {};
      _polylines = {};
    });
    _fullRoutePoints.clear();
    _passedPointIndex = 0;
    _driverPosition = null;
    _driverBearing = 0;
    _initLocationStream();
  }
}
