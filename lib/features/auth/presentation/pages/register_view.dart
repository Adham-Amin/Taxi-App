import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/widgets/custom_back_button.dart';
import 'package:taxi_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:taxi_app/features/auth/data/repositories/auth_repo.dart';
import 'package:taxi_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taxi_app/features/auth/presentation/widgets/register_view_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, required this.role});

  final String role;

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
          title: Text(
            '${LocaleKeys.become_a.tr()} ${role == 'user' ? LocaleKeys.user.tr() : LocaleKeys.driver.tr()}',
          ),
        ),
        body: RegisterViewBody(role: role),
      ),
    );
  }
}
