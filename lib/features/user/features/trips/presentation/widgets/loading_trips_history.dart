import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/features/user/features/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_card.dart';

class LoadingTripsHistory extends StatelessWidget {
  const LoadingTripsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 3,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => 16.hs,
        itemBuilder: (context, index) => TripCard(
          trip: TripEntity(
            userName: 'John Doe',
            driverName: 'John Doe',
            originAddress: '123 Main St',
            destinationAddress: '456 Elm St',
            status: 'done',
            price: 20.00,
            date: '2023-06-01',
          ),
        ),
      ),
    );
  }
}
