import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/helper/map_helper.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/utils/egypt_geo.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:taxi_app/features/user/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';

class LocationPickerViewBody extends StatefulWidget {
  const LocationPickerViewBody({super.key, this.initialLocation, this.title});

  final LocationModel? initialLocation;
  final String? title;

  @override
  State<LocationPickerViewBody> createState() => _LocationPickerViewBodyState();
}

class _LocationPickerViewBodyState extends State<LocationPickerViewBody> {
  GoogleMapController? _mapController;
  Timer? _debounce;
  Timer? _searchDebounce;
  late final TextEditingController _searchController;

  late final CameraPosition _initialCameraPosition;
  late LatLng _centerTarget;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final initial = widget.initialLocation;
    _centerTarget = initial != null
        ? LatLng(initial.lat, initial.lng)
        : EgyptGeo.center;
    _initialCameraPosition = CameraPosition(
      target: _centerTarget,
      zoom: initial != null ? 16 : 5,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initial != null) {
        // Resolve the address for the starting position so confirm works
        // even before the user moves the map.
        _resolveCenter();
      } else {
        // No starting point: open on the user's current location immediately.
        context.read<MapCubit>().getCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchDebounce?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Reverse-geocode is debounced on camera idle to respect Nominatim's
  // 1 request/second limit when the user nudges the map repeatedly.
  void _onCameraIdle() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _resolveCenter);
  }

  void _resolveCenter() {
    if (!mounted) return;
    context.read<MapCubit>().reverseGeocode(
      lat: _centerTarget.latitude,
      lng: _centerTarget.longitude,
    );
  }

  void _onConfirm(GoogleMapState state) {
    if (state is! AddressLoaded) return;
    if (!EgyptGeo.isInside(state.location.lat, state.location.lng)) {
      customSnackBar(
        context: context,
        message: LocaleKeys.location_outside_egypt.tr(),
        type: AnimatedSnackBarType.warning,
      );
      return;
    }
    Navigator.of(context).pop(state.location);
  }

  Future<void> _onCurrentLocationLoaded(LocationModel location) async {
    final target = LatLng(location.lat, location.lng);
    _centerTarget = target;
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 16),
        ),
      );
    }
    _resolveCenter();
  }

  void _onSearchChanged(String value) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (value.trim().isNotEmpty) {
        context.read<MapCubit>().getPickUpPlaces(query: value);
      } else {
        context.read<MapCubit>().clearPlaces();
      }
    });
  }

  Future<void> _onPlaceSelected(PlaceEntity place) async {
    FocusScope.of(context).unfocus();
    _searchController.text = place.displayName;
    context.read<MapCubit>().clearPlaces();

    final target = LatLng(place.lat.toDouble(), place.lon.toDouble());
    _centerTarget = target;
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 16),
        ),
      );
    }
    _resolveCenter();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: BlocListener<MapCubit, GoogleMapState>(
        listenWhen: (_, current) =>
            current is CurrentLocationLoaded || current is GoogleMapError,
        listener: (context, state) {
          if (state is CurrentLocationLoaded) {
            _onCurrentLocationLoaded(state.location);
          } else if (state is GoogleMapError) {
            customSnackBar(
              context: context,
              message: state.failure,
              type: AnimatedSnackBarType.warning,
            );
          }
        },
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              cameraTargetBounds: CameraTargetBounds(EgyptGeo.bounds),
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) {
                _mapController = controller;
                MapHelper.applyMapStyle(controller, isLight);
              },
              onCameraMove: (position) => _centerTarget = position.target,
              onCameraIdle: _onCameraIdle,
            ),
            // Fixed center pin floating above the map center.
            const Center(child: _CenterPin()),
            _buildBackButton(),
            _buildSearchBar(),
            _buildBottomCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 0,
      left: 64,
      right: 12,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: _searchController,
                hintText: LocaleKeys.search_destinations.tr(),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.lightGreen,
                ),
                onChanged: _onSearchChanged,
              ),
              _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<MapCubit, GoogleMapState>(
      builder: (context, state) {
        final places = context.read<MapCubit>().pickUpPlaces;
        if (state is! PlacesLoaded || places.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: AppColors.dark.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.lightGreen.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: AppColors.slateGray.withValues(alpha: 0.3),
            ),
            itemCount: places.length > 5 ? 5 : places.length,
            itemBuilder: (context, index) => ListTile(
              dense: true,
              leading: const Icon(
                Icons.location_on,
                color: AppColors.lightGreen,
                size: 20,
              ),
              title: Text(
                places[index].displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.textRegular14.copyWith(
                  color: AppColors.offWhite,
                ),
              ),
              onTap: () => _onPlaceSelected(places[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            color: AppColors.dark.withValues(alpha: 0.7),
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.offWhite),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCard() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.dark.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.lightGreen.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title ?? LocaleKeys.select_location.tr(),
                style: AppStyles.textBold18.copyWith(color: AppColors.offWhite),
              ),
              12.hs,
              BlocBuilder<MapCubit, GoogleMapState>(
                builder: (context, state) => _buildAddressRow(state),
              ),
              20.hs,
              BlocBuilder<MapCubit, GoogleMapState>(
                builder: (context, state) {
                  final ready = state is AddressLoaded;
                  return Opacity(
                    opacity: ready ? 1 : 0.5,
                    child: CustomButton(
                      title: LocaleKeys.confirm_location.tr(),
                      onTap: ready ? () => _onConfirm(state) : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressRow(GoogleMapState state) {
    final String text;
    if (state is AddressLoaded) {
      text = state.location.fullAddress.isNotEmpty
          ? state.location.fullAddress
          : LocaleKeys.move_map_to_select.tr();
    } else if (state is GoogleMapError) {
      text = state.failure;
    } else {
      text = LocaleKeys.locating_address.tr();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: AppColors.lightGreen, size: 20),
        8.ws,
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.textRegular14.copyWith(
              color: AppColors.mutedSlateGray,
            ),
          ),
        ),
        if (state is AddressLoading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.lightGreen,
            ),
          ),
      ],
    );
  }
}

class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    // Offset upward so the pin tip points to the exact map center.
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Icon(
        Icons.location_on,
        color: AppColors.lightGreen,
        size: 48,
        shadows: [
          Shadow(
            color: AppColors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
