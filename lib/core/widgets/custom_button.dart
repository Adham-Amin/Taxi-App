import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.colorText,
    this.isLoading = false,
    this.shadeColor,
    this.icon,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? shadeColor;
  final Color? colorText;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadeColor ?? Color(0x3300C853),
              blurRadius: 24,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              backgroundColor ?? AppColors.lightGreen,
              backgroundColor ?? AppColors.green,
            ],
          ),
        ),
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: CircularProgressIndicator(
                    color: colorText ?? AppColors.white,
                  ),
                ),
              )
            : Row(
                spacing: 8.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ?icon,
                  Text(
                    title,
                    style: AppStyles.textBold18.copyWith(
                      color: colorText ?? AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
