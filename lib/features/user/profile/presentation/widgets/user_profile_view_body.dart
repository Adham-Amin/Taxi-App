// ignore_for_file: use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/logout_button.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/personal_info_section.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/profile_header.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/section_header.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/settings_section.dart';

class UserProfileViewBody extends StatelessWidget {
  const UserProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        final isLoading = state is UserProfileLoading;
        final user = state is UserProfileLoaded
            ? state.user!
            : UserInfoModel(
                name: 'Adham Amin',
                email: 'adham.amin@gmail.com',
                phone: '+201012345678',
                image: 'https://i.pravatar.cc/300',
                role: 'user',
                id: '',
              );

        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                12.hs,
                ProfileHeader(user: user),
                24.hs,
                SectionHeader(
                  title: LocaleKeys.personal_info.tr(),
                  onEdit: () async {
                    var result = await context.push(AppRoutes.userEditProfile);

                    if (result == true) {
                      context.read<UserProfileCubit>().getUserProfile();
                    }
                  },
                ),
                12.hs,
                PersonalInfoSection(user: user),
                24.hs,
                SectionHeader(title: LocaleKeys.settings.tr()),
                12.hs,
                const SettingsSection(),
                32.hs,
                const LogoutButton(),
                32.hs,
              ],
            ),
          ),
        );
      },
    );
  }
}
