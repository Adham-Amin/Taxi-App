import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/driver/driver_trips/presentation/cubit/driver_trips_cubit.dart';
import 'package:taxi_app/features/user/trips/domain/entities/trip_entity.dart';
import 'package:taxi_app/features/user/trips/presentation/widgets/empty_trips_history.dart';
import 'package:taxi_app/features/user/trips/presentation/widgets/trip_card.dart';

class DriverTripsViewBody extends StatelessWidget {
  const DriverTripsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverTripsCubit, DriverTripsState>(
      builder: (context, state) {
        if (state is DriverTripsLoaded) {
          if (state.trips.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip History', style: AppStyles.textExtraBold30),
                  const Spacer(),
                  const EmptyTripsHistory(),
                  const Spacer(),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trip History', style: AppStyles.textExtraBold30),
                4.hs,
                Text(
                  '${state.trips.length} trips total',
                  style: AppStyles.textMedium14.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                16.hs,
                TripsHistoryIngoCard(trip: state.trips),
                24.hs,
                Expanded(
                  child: ListView.separated(
                    itemCount: state.trips.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => 16.hs,
                    itemBuilder: (context, index) =>
                        TripCard(trip: state.trips[index], isDriver: true),
                  ),
                ),
              ],
            ),
          );
        } else if (state is DriverTripsError) {
          return Center(child: Text(state.message));
        } else if (state is DriverTripsLoading) {
          return LoadingDriverTrips();
        } else {
          return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}

class LoadingDriverTrips extends StatelessWidget {
  const LoadingDriverTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip History', style: AppStyles.textExtraBold30),
          4.hs,
          Text(
            '2 trips total',
            style: AppStyles.textMedium14.copyWith(color: AppColors.accent),
          ),
          16.hs,
          TripsHistoryIngoCard(
            trip: [
              TripEntity(
                userName: 'John Doe',
                driverName: 'John Doe',
                originAddress: '123 Main St',
                destinationAddress: '456 Elm St',
                status: 'done',
                price: 200.00,
                date: '2023-06-01',
              ),
            ],
          ),
          24.hs,
          Expanded(
            child: ListView.separated(
              itemCount: 2,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => 16.hs,
              itemBuilder: (context, index) => TripCard(
                trip: TripEntity(
                  userName: 'John Doe',
                  driverName: 'John Doe',
                  originAddress: '123 Main St',
                  destinationAddress: '456 Elm St',
                  status: 'done',
                  price: 200.00,
                  date: '2023-06-01',
                ),
                isDriver: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TripsHistoryIngoCard extends StatelessWidget {
  const TripsHistoryIngoCard({super.key, required this.trip});

  final List<TripEntity> trip;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? AppColors.white : AppColors.darkBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TripsInfoItem(
            label: 'TOTAL EARNED',
            value:
                '\$${(trip.map((e) => e.price).reduce((value, element) => value + element)).toStringAsFixed(2)}',
            colorValue: AppColors.lightGreen,
          ),
          Container(width: 1, color: AppColors.accent, height: 40),
          TripsInfoItem(label: 'TRIPS', value: '${trip.length}'),
          Container(width: 1, color: AppColors.accent, height: 40),
          TripsInfoItem(
            label: 'Avg Fare',
            value:
                '\$${(trip.map((e) => e.price).reduce((value, element) => value + element) / trip.length).toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

class TripsInfoItem extends StatelessWidget {
  const TripsInfoItem({
    super.key,
    required this.label,
    required this.value,
    this.colorValue,
  });

  final String label;
  final String value;
  final Color? colorValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppStyles.textBold12.copyWith(color: AppColors.accent),
        ),
        8.hs,
        Text(
          value,
          style: AppStyles.textExtraBold24.copyWith(
            color: colorValue,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
