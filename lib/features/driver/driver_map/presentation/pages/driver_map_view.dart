import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/services/api_service.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/features/driver/driver_map/data/datasources/driver_map_data_source.dart';
import 'package:taxi_app/features/driver/driver_map/data/repositories/driver_map_repo_impl.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/cubit/driver_map_cubit.dart';
import 'package:taxi_app/features/driver/driver_map/presentation/widgets/driver_map_view_body.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/user/home/data/datasources/google_map_data_source.dart';
import 'package:taxi_app/features/user/home/data/repositories/google_map_repo_impl.dart';
import 'package:taxi_app/features/user/home/presentation/manager/map_cubit/google_map_cubit.dart';

class DriverMapView extends StatelessWidget {
  const DriverMapView({super.key, required this.offer});

  final OfferEntity offer;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DriverMapCubit(
            driverMapRepo: DriverMapRepoImpl(
              dataSource: DriverMapDataSourceImpl(),
            ),
          )..startTrip(tripId: offer.id),
        ),
        BlocProvider(
          create: (context) => MapCubit(
            googleMapRepo: MapRepoImpl(
              locationService: LocationServices(),
              googleMapDataSource: MapDataSourceImpl(
                apiService: ApiService(Dio()),
              ),
            ),
          ),
        ),
      ],
      child: Scaffold(body: DriverMapViewBody(offer: offer)),
    );
  }
}
