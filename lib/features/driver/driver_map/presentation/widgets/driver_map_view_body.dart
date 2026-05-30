import 'dart:async';
import 'dart:ui';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/helper/animated_driver_marker.dart';
import 'package:taxi_app/core/helper/map_helper.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/theme_cubit/theme_cubit.dart';
import 'package:taxi_app/core/theme_cubit/theme_state.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/animated_wrappers.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/premium_snack_bar.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/cubit/driver_map_cubit.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/widgets/driver_loading.dart';
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

class _DriverMapViewBodyState extends State<DriverMapViewBody>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  StreamSubscription? _locationSubscription;
  final LocationServices _locationService = LocationServices();

  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  List<LatLng> _fullRoutePoints = [];
  int _passedPointIndex = 0;

  String? darkMapStyle;
  Type? _lastPhaseType;

  late CameraPosition _initialCameraPosition;
  LatLng? _currentDriverPos;
  double _driverBearing = 0;

  late AnimationController _markerMoveCtrl;
  late Animation<double> _markerMoveAnim;
  LatLng? _markerAnimStart;
  LatLng? _markerAnimEnd;

  late AnimationController _panelCtrl;
  late Animation<Offset> _panelSlide;
  late Animation<double> _panelFade;

  @override
  void initState() {
    super.initState();
    MapHelper.loadMapStyle();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.offer.pickup.lat, widget.offer.pickup.lng),
      zoom: 15,
    );

    // Marker movement animation
    _markerMoveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _markerMoveAnim = CurvedAnimation(
      parent: _markerMoveCtrl,
      curve: Curves.easeInOut,
    );
    _markerMoveCtrl.addListener(_onMarkerMoveTick);

    // Bottom panel animation
    _panelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic));
    _panelFade = CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationSubscription?.cancel();
    _markerMoveCtrl.dispose();
    _panelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

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
            _buildMap(isLight),
            if (state is DriverMapTripCompleted)
              AnimatedFadeIn(
                child: TripDoneOverlay(
                  trip: state.trip,
                  onDone: () => context.read<DriverMapCubit>().doneRide(),
                ),
              )
            else if (state is DriverMapGoingToPickup ||
                state is DriverMapArrivedAtPickup ||
                state is DriverMapOnTrip)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildAnimatedBottomPanel(state),
              ),
            if (state is DriverMapLoading || state is DriverMapInitial)
              AnimatedFadeIn(child: DriverLoading()),
            if (state is DriverMapGoingToPickup ||
                state is DriverMapArrivedAtPickup ||
                state is DriverMapOnTrip)
              _buildStatusPill(state),
          ],
        );
      },
    );
  }

  Widget _buildMap(bool isLight) {
    return BlocListener<ThemeCubit, ThemeState>(
      listener: (context, state) {
        if (_mapController != null) {
          MapHelper.applyMapStyle(
            _mapController!,
            state.themeMode == ThemeMode.light,
          );
        }
      },
      child: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) async {
          _mapController = controller;
          MapHelper.applyMapStyle(controller, isLight);
        },
      ),
    );
  }

  Widget _buildStatusPill(DriverMapState state) {
    String label;
    Color color;
    IconData icon;

    if (state is DriverMapGoingToPickup) {
      label = 'Heading to pickup';
      color = const Color(0xFF2196F3);
      icon = Icons.directions_car_rounded;
    } else if (state is DriverMapArrivedAtPickup) {
      label = 'Arrived at pickup';
      color = const Color(0xFF00C853);
      icon = Icons.location_on_rounded;
    } else {
      label = 'On trip';
      color = const Color(0xFFFF6B35);
      icon = Icons.navigation_rounded;
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedFadeIn(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E).withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: color.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(icon, color: color, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBottomPanel(DriverMapState state) {
    return SlideTransition(
      position: _panelSlide,
      child: FadeTransition(
        opacity: _panelFade,
        child: _buildBottomPanel(state),
      ),
    );
  }

  Widget _buildBottomPanel(DriverMapState state) {
    final String actionTitle;
    final VoidCallback actionOnTap;
    final Color buttonColor;
    final Color textColor;
    String? userPhone;

    if (state is DriverMapGoingToPickup) {
      actionTitle = 'Arrived';
      actionOnTap = () {
        context.read<DriverMapCubit>().arrivedAtPickup();
        _showDriverArrivedSnackBar();
      };
      buttonColor = AppColors.darkSlateGray;
      textColor = AppColors.white;
      userPhone = state.trip.user.phone;
    } else if (state is DriverMapArrivedAtPickup) {
      actionTitle = 'Start Trip';
      actionOnTap = () => context.read<DriverMapCubit>().startRide();
      buttonColor = AppColors.lightGreen;
      textColor = AppColors.darkGreen;
      userPhone = state.trip.user.phone;
    } else if (state is DriverMapOnTrip) {
      actionTitle = 'End Trip';
      actionOnTap = () => context.read<DriverMapCubit>().endRide();
      buttonColor = AppColors.red;
      textColor = AppColors.white;
      userPhone = state.trip.user.phone;
    } else {
      return const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            20.w,
            20.h,
            20.w,
            MediaQuery.of(context).padding.bottom + 20.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F1A).withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: const Border(
              top: BorderSide(color: Color(0xFF2A2A3E), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 40,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              UserInfoPanel(offer: widget.offer, userPhone: userPhone),
              16.hs,
              TripActionButton(
                title: actionTitle,
                onTap: actionOnTap,
                color: buttonColor,
                textColor: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDriverArrivedSnackBar() {
    PremiumSnackBar.show(
      context,
      icon: Icons.location_on_rounded,
      message: 'You\'ve arrived at the pickup!',
      color: const Color(0xFF00C853),
    );
  }

  void _onPhaseChanged(DriverMapState state) {
    _panelCtrl.reset();
    _panelCtrl.forward();

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
    _fullRoutePoints.clear();
    _passedPointIndex = 0;

    final pickupLatLng = LatLng(
      widget.offer.pickup.lat,
      widget.offer.pickup.lng,
    );
    _markers.add(MapHelper.buildPickupMarker(pickup: pickupLatLng));

    _startDriverLocationStream(destination: pickupLatLng);

    try {
      final driverLocation = await _locationService.getCurrentLocation();
      final driverLatLng = LatLng(driverLocation.lat, driverLocation.lng);
      _currentDriverPos = driverLatLng;

      await _rebuildDriverMarker(driverLatLng);

      if (!mounted) return;
      await context.read<MapCubit>().getPolylinePoints(
        origin: driverLatLng,
        destination: pickupLatLng,
      );

      if (!mounted) return;
      _fullRoutePoints = context.read<MapCubit>().polylinePoints;
      _buildInitialPolylines();

      await _fitBoundsForRoute();
    } catch (_) {}
  }

  Future<void> _setupArrivedAtPickupPhase(
    DriverMapArrivedAtPickup state,
  ) async {
    _locationSubscription?.cancel();

    final pickupLatLng = LatLng(
      widget.offer.pickup.lat,
      widget.offer.pickup.lng,
    );
    final destLatLng = LatLng(
      widget.offer.destination.lat,
      widget.offer.destination.lng,
    );

    _markers.removeWhere((m) => m.markerId.value == 'myLocation');
    _markers.add(MapHelper.buildPickupMarker(pickup: pickupLatLng));
    _markers.add(MapHelper.buildDestinationMarker(destination: destLatLng));

    if (_currentDriverPos != null) {
      await _rebuildDriverMarker(_currentDriverPos!);
    }

    _polylines.clear();
    _fullRoutePoints.clear();
    _passedPointIndex = 0;

    if (mounted) setState(() {});

    try {
      if (!mounted) return;
      await context.read<MapCubit>().getPolylinePoints(
        origin: pickupLatLng,
        destination: destLatLng,
      );

      if (!mounted) return;
      _fullRoutePoints = context.read<MapCubit>().polylinePoints;
      _buildInitialPolylines();

      await _fitBoundsForRoute();
    } catch (_) {}
  }

  Future<void> _setupOnTripPhase(DriverMapOnTrip state) async {
    final destLatLng = LatLng(
      widget.offer.destination.lat,
      widget.offer.destination.lng,
    );

    _markers.removeWhere((m) => m.markerId.value != 'driver_marker');
    _markers.add(MapHelper.buildDestinationMarker(destination: destLatLng));

    _polylines.clear();
    _fullRoutePoints.clear();
    _passedPointIndex = 0;

    _startDriverLocationStream(destination: destLatLng);

    try {
      final driverLocation = await _locationService.getCurrentLocation();
      final driverLatLng = LatLng(driverLocation.lat, driverLocation.lng);

      if (!mounted) return;
      await context.read<MapCubit>().getPolylinePoints(
        origin: driverLatLng,
        destination: destLatLng,
      );

      if (!mounted) return;
      _fullRoutePoints = context.read<MapCubit>().polylinePoints;
      _buildInitialPolylines();

      await _fitBoundsForRoute();
    } catch (_) {}
  }

  void _startDriverLocationStream({required LatLng destination}) {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.getLocationStream().listen((
      location,
    ) async {
      if (location.latitude == null || location.longitude == null) return;

      final newPos = LatLng(location.latitude!, location.longitude!);

      if (_currentDriverPos != null) {
        _driverBearing = calculateBearing(_currentDriverPos!, newPos);
        _animateMarkerMovement(_currentDriverPos!, newPos);
        _updateProgressivePolyline(newPos);

        await MapHelper.smoothCameraFollow(
          _mapController!,
          newPos,
          zoom: 17.5,
          bearing: _driverBearing,
        );
      }

      _currentDriverPos = newPos;
    });
  }

  void _animateMarkerMovement(LatLng start, LatLng end) {
    _markerAnimStart = start;
    _markerAnimEnd = end;
    _markerMoveCtrl
      ..reset()
      ..forward();
  }

  void _onMarkerMoveTick() async {
    if (_markerAnimStart == null || _markerAnimEnd == null) return;
    final t = _markerMoveAnim.value;
    final interpolated = lerpLatLng(_markerAnimStart!, _markerAnimEnd!, t);
    await _rebuildDriverMarker(interpolated);
  }

  Future<void> _rebuildDriverMarker(LatLng position) async {
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
        zIndexInt: 3,
      ),
    );

    if (mounted) setState(() {});
  }

  void _buildInitialPolylines() {
    _polylines = MapHelper.buildInitialPolylines(_fullRoutePoints);
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

  Future<void> _fitBoundsForRoute() async {
    if (_mapController == null || _fullRoutePoints.isEmpty) return;
    await MapHelper.fitBounds(
      controller: _mapController!,
      points: _fullRoutePoints,
      padding: 80,
    );
  }
}
