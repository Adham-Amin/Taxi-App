import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/widgets/custom_back_button.dart';
import 'package:taxi_app/features/user/features/profile/data/datasources/user_profile_data_source.dart';
import 'package:taxi_app/features/user/features/profile/data/repositories/user_profile_repo_impl.dart';
import 'package:taxi_app/features/user/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/change_password_user_view_body.dart';

class ChangePasswordUserView extends StatelessWidget {
  const ChangePasswordUserView({super.key});

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
          title: Text(LocaleKeys.change_password.tr()),
        ),
        body: SafeArea(child: ChangePasswordUserViewBody()),
      ),
    );
  }
}
