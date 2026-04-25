import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/theme_cubit/theme_cubit.dart';
import 'package:taxi_app/core/theme_cubit/theme_state.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/button_tile.dart';

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
          title: LocaleKeys.dark_mode.tr(),
          trailing: Switch(
            value: state.isDark,
            activeThumbColor: AppColors.lightGreen,
            inactiveThumbColor: AppColors.lightGreen,
            activeTrackColor: AppColors.softGray,
            inactiveTrackColor: AppColors.offWhite,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme(value);
            },
          ),
        );
      },
    );
  }
}
