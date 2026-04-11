import 'package:flutter/material.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_drawer.dart';
import 'package:taxi_app/features/user/features/home/presentation/widgets/user_home_view_body.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Crazy Taxi', style: AppStyles.textExtraBold24),
      ),
      body: SafeArea(child: UserHomeViewBody()),
      drawer: CustomDrawer(selectedIndex: 0, onIndexChanged: (index) {}),
    );
  }
}
