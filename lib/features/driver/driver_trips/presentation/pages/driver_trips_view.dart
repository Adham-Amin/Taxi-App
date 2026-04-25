import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/driver/driver_trips/data/datasources/driver_trips_remote_data_source.dart';
import 'package:taxi_app/features/driver/driver_trips/data/repositories/driver_trips_repo_impl.dart';
import 'package:taxi_app/features/driver/driver_trips/presentation/cubit/driver_trips_cubit.dart';
import 'package:taxi_app/features/driver/driver_trips/presentation/widgets/driver_trips_view_body.dart';

class DriverTripsView extends StatelessWidget {
  const DriverTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverTripsCubit(
        driverTripsRepo: DriverTripsRepoImpl(
          tripRemoteDataSource: DriverTripsRemoteDataSourceImpl(),
        ),
      )..listenToTrips(),
      child: Scaffold(body: SafeArea(child: const DriverTripsViewBody())),
    );
  }
}
