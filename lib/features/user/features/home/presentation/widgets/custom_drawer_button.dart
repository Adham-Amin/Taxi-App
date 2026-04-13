import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Builder(
        builder: (context) {
          return Container(
            margin: const EdgeInsets.only(top: 16, left: 16),
            decoration: BoxDecoration(
              color: AppColors.dark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          );
        },
      ),
    );
  }
}
