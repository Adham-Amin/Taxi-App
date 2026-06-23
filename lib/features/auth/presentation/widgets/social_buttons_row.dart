import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taxi_app/features/auth/presentation/widgets/social_button.dart';

class SocialButtonsRow extends StatelessWidget {
  const SocialButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 8.w,
          children: [
            Expanded(child: Divider(thickness: 1.2)),
            Text(LocaleKeys.or.tr(), style: AppStyles.textRegular14),
            Expanded(child: Divider(thickness: 1.2)),
          ],
        ),
        16.hs,
        BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (_, current) => current is AuthGoogleNeedsProfile,
          listener: (context, state) {
            if (state is AuthGoogleNeedsProfile) {
              context.push(AppRoutes.completeProfile, extra: state.googleData);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SocialButton(
              text: LocaleKeys.login_with_google.tr(),
              borderColor: AppColors.darkGrey,
              iconPath: AppAssets.iconsLogosGoogleIcon,
              onPressed: isLoading
                  ? () {}
                  : () => context.read<AuthCubit>().loginWithGoogle(),
            );
          },
        ),
      ],
    );
  }
}
