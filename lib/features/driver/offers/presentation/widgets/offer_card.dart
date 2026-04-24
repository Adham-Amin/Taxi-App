import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/label_text.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/driver/offers/presentation/widgets/offer_route_info.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.onAccept,
    this.isLoading = false,
  });

  final OfferEntity offer;
  final VoidCallback onAccept;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.darkGrey,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 16.h),
          OfferRouteInfo(
            pickupAddress: offer.pickup.fullAddress,
            destinationAddress: offer.destination.fullAddress,
          ),
          SizedBox(height: 20.h),
          CustomButton(
            title: 'Accept',
            onTap: onAccept,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
        SizedBox(width: 12.w),
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
            const LabelText(text: 'OFFER PRICE'),
            SizedBox(height: 2.h),
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
