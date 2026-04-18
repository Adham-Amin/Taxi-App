import 'package:flutter/material.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/location_item.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';

class LocationTexts extends StatelessWidget {
  const LocationTexts({super.key, required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: LocationItem(title: 'PICKUP', value: trip.originAddress),
          ),
          LocationItem(title: 'DESTINATION', value: trip.destinationAddress),
        ],
      ),
    );
  }
}
