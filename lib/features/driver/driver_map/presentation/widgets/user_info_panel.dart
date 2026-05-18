import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/features/driver/offers/domain/entities/offer_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoPanel extends StatelessWidget {
  const UserInfoPanel({
    super.key,
    required this.offer,
    this.userPhone,
  });

  final OfferEntity offer;
  final String? userPhone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildUserImage(),
              16.ws,
              Expanded(child: _buildNameAndEarning()),
            ],
          ),
          Divider(
            height: 24,
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildUserImage() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGreen, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Image.network(
          offer.image,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Icon(
            Icons.person,
            color: AppColors.lightGreen,
            size: 32.w,
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndEarning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offer.name,
          style: AppStyles.textBold18.copyWith(color: AppColors.light),
        ),
        4.hs,
        Row(
          children: [
            Text(
              'EARNING',
              style: AppStyles.textRegular12.copyWith(
                color: AppColors.slateGray,
                letterSpacing: 1,
              ),
            ),
            8.ws,
            Text(
              '\$${offer.price.toStringAsFixed(2)}',
              style: AppStyles.textBold20.copyWith(
                color: AppColors.lightGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            title: 'Message',
            onTap: () {},
            colorText: isLight ? AppColors.dark : AppColors.light,
            backgroundColor: isLight ? AppColors.offWhite : AppColors.darkGrey,
            shadeColor: Colors.transparent,
            icon: Icon(Icons.message_outlined, color: AppColors.lightGreen),
          ),
        ),
        12.ws,
        Expanded(
          child: CustomButton(
            title: 'Call',
            onTap: userPhone != null && userPhone!.isNotEmpty
                ? () => launchUrl(Uri.parse('tel:$userPhone'))
                : null,
            colorText: isLight ? AppColors.dark : AppColors.light,
            backgroundColor: isLight ? AppColors.offWhite : AppColors.darkGrey,
            shadeColor: Colors.transparent,
            icon: Icon(Icons.call_outlined, color: AppColors.lightGreen),
          ),
        ),
      ],
    );
  }
}
