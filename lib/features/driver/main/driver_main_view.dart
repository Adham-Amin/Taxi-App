import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';

class DriverMainView extends StatefulWidget {
  const DriverMainView({super.key});

  static final GlobalKey<MainPageState> mainViewKey = GlobalKey();

  @override
  State<DriverMainView> createState() => MainPageState();
}

class MainPageState extends State<DriverMainView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home')),
    Center(child: Text('Trips')),
    Center(child: Text('Settings')),
  ];

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        decoration: BoxDecoration(
          color: isLight ? AppColors.white : Colors.black,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: .2),
            ),
          ],
        ),
        child: GNav(
          curve: Curves.easeOutExpo,
          haptic: true,
          gap: 4,
          color: AppColors.slateGray,
          activeColor: AppColors.lightGreen,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          textStyle: AppStyles.textBold18.copyWith(color: AppColors.lightGreen),
          tabs: const [
            GButton(icon: Icons.home, text: 'home'),
            GButton(icon: Icons.directions_car, text: 'Trips'),
            GButton(icon: Icons.settings_outlined, text: 'Settings'),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}
