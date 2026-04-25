import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';

class OfferCardHeader extends StatelessWidget {
  const OfferCardHeader({super.key, required this.offer});

  final OfferEntity offer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.lightGreen.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(offer.image),
            backgroundColor: AppColors.darkGrey,
          ),
        ),
        12.ws,
        Expanded(
          child: Text(
            offer.name,
            style: AppStyles.textBold16.copyWith(color: AppColors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'OFFER PRICE',
              style: AppStyles.textRegular10.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
                letterSpacing: 1,
              ),
            ),
            Text(
              '\$${offer.price.toStringAsFixed(2)}',
              style: AppStyles.textExtraBold24.copyWith(
                color: AppColors.lightGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
