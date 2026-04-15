import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/location_fields_column.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/location_icons_column.dart';

class MapSearchCard extends StatelessWidget {
  const MapSearchCard({
    super.key,
    required this.currentLocation,
    required this.destLocation,
  });

  final Function(LocationModel) currentLocation;
  final Function(LocationModel) destLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationIconsColumn(),
          16.ws,
          Expanded(
            child: LocationFieldsColumn(
              currentLocation: currentLocation,
              destination: destLocation,
            ),
          ),
        ],
      ),
    );
  }
}
