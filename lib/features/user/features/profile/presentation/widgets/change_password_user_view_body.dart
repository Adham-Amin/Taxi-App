import 'package:flutter/material.dart';

class ChangePasswordUserViewBody extends StatefulWidget {
  const ChangePasswordUserViewBody({super.key});

  @override
  State<ChangePasswordUserViewBody> createState() =>
      _ChangePasswordUserViewBodyState();
}

class _ChangePasswordUserViewBodyState
    extends State<ChangePasswordUserViewBody> {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
