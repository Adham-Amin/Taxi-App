import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/user/profile/data/datasources/user_profile_data_source.dart';
import 'package:taxi_app/features/user/profile/data/repositories/user_profile_repo_impl.dart';
import 'package:taxi_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/user_profile_view_body.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit(
        userProfileRepo: UserProfileRepoImpl(
          userProfileDataSource: UserProfileDataSourceImpl(),
        ),
      )..getUserProfile(),
      child: const Scaffold(body: SafeArea(child: UserProfileViewBody())),
    );
  }
}
