import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/services/api_service.dart';
import 'package:taxi_app/features/user/home/data/datasources/google_map_data_source.dart';
import 'package:taxi_app/features/user/home/data/datasources/trip_data_source.dart';
import 'package:taxi_app/features/user/home/data/repositories/google_map_repo_impl.dart';
import 'package:taxi_app/features/user/home/data/repositories/trip_repo_impl.dart';
import 'package:taxi_app/features/user/home/presentation/manager/cubit/trip_cubit.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/user_home_view_body.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapCubit(
            googleMapRepo: MapRepoImpl(
              googleMapDataSource: MapDataSourceImpl(
                apiService: ApiService(Dio()),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => TripCubit(
            tripRepo: TripRepoImpl(tripDataSource: TripDataSourceImpl()),
          ),
        ),
      ],
      child: Scaffold(body: SafeArea(child: UserHomeViewBody())),
    );
  }
}
