import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:taxi_app/features/driver/offers/presentation/widgets/offer_card_header.dart';
import 'package:taxi_app/core/widgets/route_info.dart';

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
        color: AppColors.darkBlack2,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        children: [
          OfferCardHeader(offer: offer),
          24.hs,
          RouteInfo(
            pickupAddress: offer.pickup.fullAddress,
            destinationAddress: offer.destination.fullAddress,
          ),
          24.hs,
          CustomButton(title: 'Accept', onTap: onAccept, isLoading: isLoading),
        ],
      ),
    );
  }
}
