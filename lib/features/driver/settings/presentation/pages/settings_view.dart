import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/driver/settings/data/datasources/driver_profile_data_source.dart';
import 'package:taxi_app/features/driver/settings/data/repositories/driver_profile_repo_impl.dart';
import 'package:taxi_app/features/driver/settings/presentation/cubit/settings_cubit.dart';
import 'package:taxi_app/features/driver/settings/presentation/widgets/settings_view_body.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(driverProfileRepo:        
        DriverProfileRepoImpl(driverProfileDataSource: DriverProfileDataSourceImpl())
      )..getDriverProfile(),
      child: const Scaffold(body: SafeArea(child: SettingsViewBody())),
    );
  }
}
