import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/user/features/trips/data/datasources/trip_history_remote_data_source.dart';
import 'package:taxi_app/features/user/features/trips/data/repositories/trip_history_repo_impl.dart';
import 'package:taxi_app/features/user/features/trips/presentation/cubit/trips_histroy_cubit.dart';
import 'package:taxi_app/features/user/features/trips/presentation/widgets/user_trips_view_body.dart';

class UserTripsView extends StatelessWidget {
  const UserTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripsHistoryCubit(
        tripHistoryRepo: TripHistoryRepoImpl(
          tripRemoteDataSource: TripHistoryRemoteDataSourceImpl(),
        ),
      )..listenToTrips(),
      child: Scaffold(body: SafeArea(child: const UserTripsViewBody())),
    );
  }
}
