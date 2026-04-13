import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/features/user/features/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/search_section.dart';

class LocationFieldsColumn extends StatefulWidget {
  const LocationFieldsColumn({
    super.key,
    required this.currentLocation,
    required this.onTap,
  });

  final Function(LatLng currentLocation) currentLocation;
  final Function(PlaceEntity) onTap;
  @override
  State<LocationFieldsColumn> createState() => _LocationFieldsColumnState();
}

class _LocationFieldsColumnState extends State<LocationFieldsColumn> {
  late TextEditingController fromController, toController;

  @override
  void initState() {
    fromController = TextEditingController();
    toController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          hintText: 'From',
          controller: fromController,
          readOnly: true,
          suffixIcon: IconButton(
            onPressed: () async {
              final loc = await LocationServices().getCurrentLocation();
              setState(() {
                widget.currentLocation(
                  LatLng(
                    loc.locationLat.toDouble(),
                    loc.locationLng.toDouble(),
                  ),
                );
                fromController.text = loc.fullAddress;
              });
            },
            icon: Icon(Icons.location_on_outlined, color: AppColors.darkRed),
          ),
        ),
        8.hs,
        SearchSection(onTap: widget.onTap),
      ],
    );
  }
}
