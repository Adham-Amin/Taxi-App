import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:svg_flutter/svg.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  final int selectedIndex;
  final Function(int index) onIndexChanged;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late SidebarXController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SidebarXController(
      selectedIndex: widget.selectedIndex,
      extended: true,
    );

    _controller.addListener(() {
      widget.onIndexChanged(_controller.selectedIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      toggleButtonBuilder: (context, extended) => Container(),
      theme: SidebarXTheme(
        width: 260.w,
        decoration: BoxDecoration(color: AppColors.dark),
        textStyle: AppStyles.textRegular14.copyWith(color: Colors.grey),
        selectedTextStyle: AppStyles.textBold14.copyWith(color: Colors.white),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [AppColors.green, AppColors.green.withValues(alpha: 0.7)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.grey, size: 22),
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 24),
        itemTextPadding: const EdgeInsets.only(left: 12),
        itemPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        selectedItemPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
        selectedItemTextPadding: const EdgeInsets.only(left: 12),
      ),
      headerDivider: const Divider(),
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
          child: Column(
            children: [
              SvgPicture.asset(AppAssets.svgsLogo, height: 60),
              12.hs,
              Text('CRAZY TAXI', style: AppStyles.textExtraBold24),
            ],
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            context.pop();
            customSnackBar(
              context: context,
              message: 'Home',
              type: AnimatedSnackBarType.success,
            );
          },
        ),
        SidebarXItem(icon: Icons.history, label: 'History Trips', onTap: () {}),
        SidebarXItem(icon: Icons.person, label: 'Profile', onTap: () {}),
      ],
    );
  }
}
