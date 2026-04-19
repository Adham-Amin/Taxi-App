// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/user/features/profile/presentation/cubit/profile_cubit.dart';

class UserProfileViewBody extends StatefulWidget {
  const UserProfileViewBody({super.key});

  @override
  State<UserProfileViewBody> createState() => _UserProfileViewBodyState();
}

class _UserProfileViewBodyState extends State<UserProfileViewBody> {
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
                image: '',
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
                  title: 'PERSONAL INFO',
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
                SectionHeader(title: 'SETTINGS'),
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

////////////////////////////////////////////////////////////
/// HEADER
////////////////////////////////////////////////////////////

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: NetworkImage(user.image!)),
        16.hs,
        Text(user.name!, style: AppStyles.textExtraBold24),
        4.hs,
        Text(
          user.email!,
          style: AppStyles.textRegular14.copyWith(color: AppColors.accent),
        ),
        16.hs,
        RoleBadge(role: user.role!),
      ],
    );
  }
}

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.darkBlack,
        borderRadius: BorderRadius.circular(60),
        border: Border.all(color: AppColors.grey, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outlined, color: AppColors.lightGreen),
          8.ws,
          Text(
            role.toUpperCase(),
            style: AppStyles.textBold12.copyWith(color: AppColors.light),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SECTION HEADER
////////////////////////////////////////////////////////////

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onEdit});

  final String title;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.textBold12.copyWith(color: AppColors.lightGrey),
        ),
        if (onEdit != null)
          GestureDetector(
            onTap: onEdit,
            child: Text(
              'Edit',
              style: AppStyles.textBold14.copyWith(color: AppColors.lightGreen),
            ),
          ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// PERSONAL INFO
////////////////////////////////////////////////////////////

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          InfoTile(
            icon: Icons.person_outlined,
            title: 'NAME',
            subtitle: user.name!,
          ),
          const CustomDivider(),
          InfoTile(
            icon: Icons.email_outlined,
            title: 'EMAIL',
            subtitle: user.email!,
          ),
          const CustomDivider(),
          InfoTile(
            icon: Icons.phone_outlined,
            title: 'PHONE',
            subtitle: user.phone!,
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SETTINGS
////////////////////////////////////////////////////////////

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
            onTap: () {},
            icon: Icons.password_outlined,
            title: 'Change Password',
          ),
          const CustomDivider(),
          ButtonTile(
            onTap: () {},
            icon: Icons.language_outlined,
            title: 'Language',
          ),
          const CustomDivider(),
          ButtonTile(
            onTap: () {},
            icon: Icons.dark_mode_outlined,
            title: 'Theme Mode',
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LOGOUT
////////////////////////////////////////////////////////////

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () async {
        context.go(AppRoutes.welcome);
        await Prefs.clearUserData();
        await FirebaseAuth.instance.signOut();
      },
      title: 'Log out',
      colorText: AppColors.lightRed,
      backgroundColor: AppColors.lightRed.withValues(alpha: 0.1),
      shadeColor: Colors.transparent,
      icon: Icon(Icons.logout_outlined, color: AppColors.lightRed),
    );
  }
}

////////////////////////////////////////////////////////////
/// SHARED COMPONENTS
////////////////////////////////////////////////////////////

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: AppColors.darkBlack,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.grey, width: 2),
  );
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 24, color: AppColors.white.withValues(alpha: 0.08));
  }
}

class ButtonTile extends StatelessWidget {
  const ButtonTile({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.lightGrey),
          8.ws,
          Text(
            title,
            style: AppStyles.textMedium16.copyWith(color: AppColors.light),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.lightGreen),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.lightGrey),
        8.ws,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.textBold12.copyWith(color: AppColors.lightGrey),
            ),
            4.hs,
            Text(
              subtitle,
              style: AppStyles.textMedium14.copyWith(color: AppColors.light),
            ),
          ],
        ),
      ],
    );
  }
}
