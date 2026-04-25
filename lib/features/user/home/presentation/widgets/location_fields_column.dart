import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
// ignore: unused_import
import 'package:taxi_app/features/user/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';
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
        CustomTextFormField(
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
            onPressed: () async {
              context.read<MapCubit>().clearPlaces();
              final loc = await LocationServices().getCurrentLocation();
              fromController.text = loc.fullAddress;
              widget.currentLocation(loc);
              setState(() {});
            },
            icon: Icon(Icons.my_location, color: AppColors.darkRed),
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
        8.hs,
        SearchSection(destination: widget.destination),
      ],
    );
  }
}
