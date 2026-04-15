import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/search_section.dart';

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

  @override
  void initState() {
    fromController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
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
              widget.currentLocation(loc);
              fromController.text = loc.fullAddress;
              setState(() {});
            },
            icon: Icon(Icons.location_on_outlined, color: AppColors.darkRed),
          ),
        ),
        8.hs,
        SearchSection(destination: widget.destination),
      ],
    );
  }
}
