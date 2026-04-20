import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/theme_cubit/theme_cubit.dart';
import 'package:taxi_app/core/theme_cubit/theme_state.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/button_tile.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/custom_divider.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
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

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: AppColors.darkBlack,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.grey, width: 2),
    );
  }
}

class DarkModeButton extends StatelessWidget {
  const DarkModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ButtonTile(
          onTap: () {
            context.read<ThemeCubit>().switchTheme();
          },
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          trailing: Switch(
            value: state.isDark,
            activeThumbColor: AppColors.lightGreen,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme(value);
            },
          ),
        );
      },
    );
  }
}
