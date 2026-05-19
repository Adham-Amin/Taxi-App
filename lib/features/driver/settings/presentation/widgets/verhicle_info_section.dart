import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/custom_divider.dart';
import 'package:taxi_app/features/user/profile/presentation/widgets/info_tile.dart';

class VerhicleInfoSection extends StatelessWidget {
  const VerhicleInfoSection({super.key, required this.user});

  final UserInfoModel user;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(isLight),
      child: Column(
        children: [
          InfoTile(
            icon: Icons.car_repair_outlined,
            title: LocaleKeys.car_model.tr(),
            subtitle: user.carModel ?? '',
          ),
          const CustomDivider(),
          InfoTile(
            icon: Icons.color_lens_outlined,
            title: LocaleKeys.vehicle_color.tr(),
            subtitle: user.carColor ?? '',
          ),
          const CustomDivider(),
          InfoTile(
            icon: Icons.numbers_outlined,
            title: LocaleKeys.vehicle_plate_number.tr(),
            subtitle: user.carPlateNumber ?? '',
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