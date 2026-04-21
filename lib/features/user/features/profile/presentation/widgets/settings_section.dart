// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/button_tile.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/custom_divider.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/dark_mode_button.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(isLight),
      child: Column(
        children: [
          ButtonTile(
            onTap: () async {
              var result = await context.push(AppRoutes.userchangeEmailProfile);

              if (result == true) {
                await context.read<UserProfileCubit>().getUserProfile();
              }
            },
            icon: Icons.email_outlined,
            title: 'Change Email',
          ),
          const CustomDivider(),
          ButtonTile(
            onTap: () {
              context.push(AppRoutes.userchangePasswordProfile);
            },
            icon: Icons.password_outlined,
            title: 'Change Password',
          ),
          const CustomDivider(),
          ButtonTile(
            onTap: () {
              context.push(AppRoutes.language);
            },
            icon: Icons.language_outlined,
            title: 'Language',
          ),
          const CustomDivider(),
          DarkModeButton(),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration(bool isLight) {
    return BoxDecoration(
      color: isLight ? AppColors.white : AppColors.darkBlack,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isLight ? AppColors.mutedSlateGray : AppColors.grey,
      ),
    );
  }
}
