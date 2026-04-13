import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/services/api_service.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_drawer.dart';
import 'package:taxi_app/features/user/features/home/data/datasources/google_map_data_source.dart';
import 'package:taxi_app/features/user/features/home/data/repositories/google_map_repo_impl.dart';
import 'package:taxi_app/features/user/features/home/presentation/cubit/google_map_cubit.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/user_home_view_body.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoogleMapCubit(
        googleMapRepo: GoogleMapRepoImpl(
          googleMapDataSource: GoogleMapDataSourceImpl(
            apiService: ApiService(Dio()),
          ),
        ),
      ),
      child: Scaffold(
        body: SafeArea(child: UserHomeViewBody()),
        drawer: CustomDrawer(selectedIndex: 0, onIndexChanged: (index) {}),
      ),
    );
  }
}
