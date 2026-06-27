import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/services/api_service.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/features/user/home/data/datasources/google_map_data_source.dart';
import 'package:taxi_app/features/user/home/data/repositories/google_map_repo_impl.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';
import 'package:taxi_app/features/user/home/presentation/widgets/location_picker_view_body.dart';

class LocationPickerView extends StatelessWidget {
  const LocationPickerView({super.key, this.initialLocation, this.title});

  final LocationModel? initialLocation;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit(
        googleMapRepo: MapRepoImpl(
          googleMapDataSource: MapDataSourceImpl(apiService: ApiService(Dio())),
          locationService: LocationServices(),
        ),
      ),
      child: LocationPickerViewBody(
        initialLocation: initialLocation,
        title: title,
      ),
    );
  }
}
