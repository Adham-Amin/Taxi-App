import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';

class DirverButtons extends StatelessWidget {
  const DirverButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            title: 'Message',
            onTap: () {},
            colorText: AppColors.lightGrey,
            backgroundColor: AppColors.darkGrey,
            shadeColor: Colors.transparent,
            child: Icon(Icons.message_outlined, color: AppColors.lightGreen),
          ),
        ),
        12.ws,
        Expanded(
          child: CustomButton(
            title: 'Call',
            onTap: () {},
            colorText: AppColors.lightGrey,
            backgroundColor: AppColors.darkGrey,
            shadeColor: Colors.transparent,
            child: Icon(Icons.call_outlined, color: AppColors.lightGreen),
          ),
        ),
      ],
    );
  }
}
