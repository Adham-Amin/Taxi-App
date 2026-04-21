import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/dot_icon.dart';

class LocationDots extends StatelessWidget {
  const LocationDots({super.key});

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: [
        4.hs,
        DotIcon(color: isLight ? AppColors.accent : AppColors.white),
        4.hs,
        Expanded(
          child: Container(
            width: 2,
            color: isLight ? Colors.black12 : Colors.white24,
          ),
        ),
        4.hs,
        DotIcon(color: AppColors.lightGreen),
        4.hs,
      ],
    );
  }
}
