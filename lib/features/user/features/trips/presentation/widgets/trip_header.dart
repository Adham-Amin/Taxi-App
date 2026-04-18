import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/done_trip_icon.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/driver_info.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_price_status.dart';

class TripHeader extends StatelessWidget {
  const TripHeader({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoneTripIcon(trip: trip),
        12.ws,
        Expanded(child: DriverInfo(trip: trip)),
        TripPriceStatus(trip: trip),
      ],
    );
  }
}
