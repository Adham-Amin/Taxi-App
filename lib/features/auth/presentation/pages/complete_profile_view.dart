import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/widgets/custom_back_button.dart';
import 'package:taxi_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/data/repositories/auth_repo.dart';
import 'package:taxi_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taxi_app/features/auth/presentation/widgets/complete_profile_view_body.dart';

class CompleteProfileView extends StatelessWidget {
  const CompleteProfileView({super.key, required this.googleData});

  final UserInfoModel googleData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authRepo: AuthRepoImpl(authDataSource: AuthDataSourceImpl()),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Center(child: const CustomBackButton()),
          scrolledUnderElevation: 0,
          title: Text(LocaleKeys.complete_profile.tr()),
        ),
        body: CompleteProfileViewBody(googleData: googleData),
      ),
    );
  }
}
