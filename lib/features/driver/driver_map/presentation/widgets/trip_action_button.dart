import 'package:flutter/material.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';

class TripActionButton extends StatelessWidget {
  const TripActionButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.color
  , this.textColor
  });

  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      title: title,
      onTap: onTap,
      isLoading: isLoading,
      backgroundColor: color,
      colorText: textColor,
    );
  }
}
