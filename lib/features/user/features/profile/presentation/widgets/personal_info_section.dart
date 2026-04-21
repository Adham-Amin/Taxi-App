import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/custom_divider.dart';
import 'package:taxi_app/features/user/features/profile/presentation/widgets/info_tile.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(isLight),
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

  BoxDecoration _boxDecoration(bool isLiaght) {
    return BoxDecoration(
      color: isLiaght ? AppColors.white : AppColors.darkBlack,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isLiaght ? AppColors.mutedSlateGray : AppColors.grey,
      ),
    );
  }
}
