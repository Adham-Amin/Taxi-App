import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/home/domain/entities/place_entity.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/location_fields_column.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/location_icons_column.dart';

class MapSearchCard extends StatelessWidget {
  const MapSearchCard({
    super.key,
    required this.currentLocation,
    required this.destLocation,
  });

  final Function(LatLng) currentLocation;
  final Function(PlaceEntity) destLocation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 24,
      right: 24,
      child: Container(
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
                onTap: destLocation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
