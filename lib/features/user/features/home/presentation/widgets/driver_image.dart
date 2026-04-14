import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class DriverImage extends StatelessWidget {
  const DriverImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGreen.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          'https://res.cloudinary.com/dquchh5v9/image/upload/v1775913983/cqlijsnv3d51xqskd7q9.webp',
          height: 64,
          width: 64,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
