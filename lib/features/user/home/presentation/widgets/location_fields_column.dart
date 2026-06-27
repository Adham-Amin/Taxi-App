import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';
import 'package:taxi_app/features/user/home/presentation/pages/location_picker_view.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/pick_on_map_button.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/pick_up_location_list.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/search_section.dart';

class LocationFieldsColumn extends StatefulWidget {
  const LocationFieldsColumn({
    super.key,
    required this.currentLocation,
    required this.destination,
  });

  final Function(LocationModel) currentLocation;
  final Function(LocationModel) destination;
  @override
  State<LocationFieldsColumn> createState() => _LocationFieldsColumnState();
}

class _LocationFieldsColumnState extends State<LocationFieldsColumn> {
  late TextEditingController fromController;
  Timer? _debounce;

  @override
  void initState() {
    fromController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocListener<MapCubit, GoogleMapState>(
          listenWhen: (_, current) => current is CurrentLocationLoaded,
          listener: (context, state) {
            if (state is CurrentLocationLoaded) {
              fromController.text = state.location.fullAddress;
              widget.currentLocation(state.location);
            }
          },
          child: CustomTextFormField(
            hintText: LocaleKeys.from.tr(),
            controller: fromController,
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 400), () {
                if (value.isNotEmpty) {
                  context.read<MapCubit>().getPickUpPlaces(query: value);
                } else {
                  context.read<MapCubit>().clearPlaces();
                }
              });
            },
            suffixIcon: IconButton(
              onPressed: () {
                context.read<MapCubit>().clearPlaces();
                context.read<MapCubit>().getCurrentLocation();
              },
              icon: Icon(Icons.my_location, color: AppColors.darkRed),
            ),
          ),
        ),
        10.hs,
        PickUpLocationList(
          onTap: (place) {
            fromController.text = place.displayName;
            context.read<MapCubit>().clearPlaces();
            final loc = LocationModel(
              lat: place.lat.toDouble(),
              lng: place.lon.toDouble(),
              fullAddress: place.displayName,
            );

            widget.currentLocation(loc);
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: PickOnMapButton(onTap: _pickPickupFromMap),
        ),
        8.hs,
        SearchSection(destination: widget.destination),
      ],
    );
  }

  Future<void> _pickPickupFromMap() async {
    final mapCubit = context.read<MapCubit>();
    mapCubit.clearPlaces();

    final result = await Navigator.of(context).push<LocationModel>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: mapCubit,
          child: LocationPickerView(title: LocaleKeys.from.tr()),
        ),
      ),
    );

    if (result == null || !mounted) return;
    fromController.text = result.fullAddress;
    widget.currentLocation(result);
  }
}
