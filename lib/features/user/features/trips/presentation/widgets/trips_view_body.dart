import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/features/user/features/trips/presentation/cubit/trips_histroy_cubit.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/empty_trips_history.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/loading_trips_history.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/trip_card.dart';

class TripsViewBody extends StatelessWidget {
  const TripsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.hs,
          Text('Trip History', style: AppStyles.textExtraBold30),
          16.hs,
          CustomTextFormField(
            hintText: 'Search destinations...',
            onChanged: (value) {
              if (value.trim().isEmpty) {
                context.read<TripsHistoryCubit>().listenToTrips();
              }
              context.read<TripsHistoryCubit>().searchTrips(
                value.toUpperCase(),
              );
            },
          ),
          16.hs,
          Expanded(
            child: BlocBuilder<TripsHistoryCubit, TripsHistoryState>(
              builder: (context, state) {
                if (state is TripsHistoryLoaded) {
                  if (state.trips.isEmpty) {
                    return const EmptyTripsHistory();
                  }
                  return Column(
                    children: [
                      Text(
                        '${state.trips.length} Total trips completed this year',
                        style: AppStyles.textSemiBold16.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                      16.hs,
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: state.trips.length,
                          separatorBuilder: (context, index) => 16.hs,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              TripCard(trip: state.trips[index]),
                        ),
                      ),
                      16.hs,
                    ],
                  );
                }
                if (state is TripsHistoryError) {
                  return Center(child: Text(state.message));
                }
                return const LoadingTripsHistory();
              },
            ),
          ),
        ],
      ),
    );
  }
}
