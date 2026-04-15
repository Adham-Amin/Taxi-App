import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/car_loading.dart';

class SearchingDriverOverlay extends StatefulWidget {
  const SearchingDriverOverlay({super.key, required this.cancelSearching});

  final VoidCallback cancelSearching;

  @override
  State<SearchingDriverOverlay> createState() => _SearchingDriverOverlayState();
}

class _SearchingDriverOverlayState extends State<SearchingDriverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1, end: 1.3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dark.withValues(alpha: 0.6),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 5),
          AnimatedBuilder(
            animation: _controller,
            child: CarLoading(),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
          ),
          40.hs,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Searching for ",
                  style: AppStyles.textExtraBold30,
                ),
                TextSpan(
                  text: "driver...",
                  style: AppStyles.textExtraBold30.copyWith(
                    color: AppColors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
          16.hs,
          Text(
            "Matching you with the best nearby\n partners at your price.",
            textAlign: TextAlign.center,
            style: AppStyles.textRegular16.copyWith(color: AppColors.accent),
          ),
          Spacer(flex: 5),
          GestureDetector(
            onTap: widget.cancelSearching,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close, color: AppColors.accent, size: 20),
                8.ws,
                Text(
                  "Cancel Request",
                  style: AppStyles.textSemiBold16.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
