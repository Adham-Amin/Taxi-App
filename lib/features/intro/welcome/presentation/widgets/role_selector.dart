import 'package:flutter/material.dart';
import 'package:taxi_app/features/intro/welcome/data/model/user_type_enum.dart';
import 'package:taxi_app/features/intro/welcome/presentation/widgets/role_button.dart';

class RoleSelector extends StatefulWidget {
  const RoleSelector({super.key, required this.onTap});

  final Function(UserTypeEnum) onTap;

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoleButton(
            title: 'User',
            isActive: currentIndex == 0,
            onTap: () {
              widget.onTap(UserTypeEnum.user);
              setState(() {
                currentIndex = 0;
              });
            },
          ),
          RoleButton(
            title: 'Driver',
            isActive: currentIndex == 1,
            onTap: () {
              widget.onTap(UserTypeEnum.driver);
              setState(() {
                currentIndex = 1;
              });
            },
          ),
        ],
      ),
    );
  }
}
