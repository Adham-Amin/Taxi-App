import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/widgets/custom_back_button.dart';
import 'package:taxi_app/features/user/features/profile/data/datasources/user_profile_data_source.dart';
import 'package:taxi_app/features/user/features/profile/data/repositories/user_profile_repo_impl.dart';
import 'package:taxi_app/features/user/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/change_email_user_view_body.dart';

class ChangeEmailUserView extends StatelessWidget {
  const ChangeEmailUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit(
        userProfileRepo: UserProfileRepoImpl(
          userProfileDataSource: UserProfileDataSourceImpl(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Center(child: CustomBackButton()),
          title: Text('Change Password'),
        ),
        body: SafeArea(child: ChangeEmailUserViewBody()),
      ),
    );
  }
}
