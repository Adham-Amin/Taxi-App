import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/intro/welcome/data/model/user_type_enum.dart';
import 'package:taxi_app/features/intro/welcome/presentation/widgets/role_button.dart';

class RoleSelector extends StatefulWidget {
  const RoleSelector({super.key, required this.onTap});

  final Function(UserTypeEnum) onTap;

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isLight ? AppColors.softGray : AppColors.dark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight
              ? AppColors.lightSlateGray.withValues(alpha: 0.3)
              : AppColors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: RoleButton(
              title: LocaleKeys.user.tr(),
              isActive: currentIndex == 0,
              onTap: () {
                widget.onTap(UserTypeEnum.user);
                setState(() {
                  currentIndex = 0;
                });
              },
            ),
          ),
          4.ws,
          Expanded(
            child: RoleButton(
              title: LocaleKeys.driver.tr(),
              isActive: currentIndex == 1,
              onTap: () {
                widget.onTap(UserTypeEnum.driver);
                setState(() {
                  currentIndex = 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
