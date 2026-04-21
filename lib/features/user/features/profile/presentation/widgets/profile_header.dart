import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/role_badge.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: NetworkImage(user.image!)),
        16.hs,
        Text(user.name!, style: AppStyles.textExtraBold24),
        4.hs,
        Text(
          user.email!,
          style: AppStyles.textRegular14.copyWith(
            color: isLight ? AppColors.slateGray : AppColors.accent,
          ),
        ),
        16.hs,
        RoleBadge(role: user.role!),
      ],
    );
  }
}
