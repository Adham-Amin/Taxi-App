import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/location_dots.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/location_texts.dart';

class TripLocations extends StatelessWidget {
  const TripLocations({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 140.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationDots(),
            16.ws,
            LocationTexts(trip: trip),
          ],
        ),
      ),
    );
  }
}
