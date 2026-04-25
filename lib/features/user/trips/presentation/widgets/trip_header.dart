import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/features/user/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/trips/presentation/widgets/done_trip_icon.dart';
import 'package:taxi_app/features/user/trips/presentation/widgets/driver_info.dart';
import 'package:taxi_app/features/user/trips/presentation/widgets/trip_price_status.dart';

class TripHeader extends StatelessWidget {
  const TripHeader({super.key, required this.trip, this.isDriver});

  final TripEntity trip;
  final bool? isDriver;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoneTripIcon(trip: trip),
        12.ws,
        Expanded(
          child: DriverInfo(trip: trip, isDriver: isDriver),
        ),
        TripPriceStatus(trip: trip),
      ],
    );
  }
}
