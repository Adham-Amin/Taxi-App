import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/functions/validators.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field_password.dart';
import 'package:taxi_app/core/widgets/label_text.dart';
import 'package:taxi_app/features/user/features/profile/presentation/cubit/profile_cubit.dart';

class ChangePasswordUserViewBody extends StatefulWidget {
  const ChangePasswordUserViewBody({super.key});

  @override
  State<ChangePasswordUserViewBody> createState() =>
      _ChangePasswordUserViewBodyState();
}

class _ChangePasswordUserViewBodyState
    extends State<ChangePasswordUserViewBody> {
  late TextEditingController passwordController, newPasswordController;
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    passwordController = TextEditingController();
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.hs,
            LabelText(text: LocaleKeys.current_password.tr()),
            6.hs,
            CustomTextFormFieldPassword(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.enter_your_password.tr();
                }
                return null;
              },
              hintText: '•••••••••••••',
            ),
            16.hs,
            LabelText(text: LocaleKeys.new_password.tr()),
            6.hs,
            CustomTextFormFieldPassword(
              controller: newPasswordController,
              validator: Validators.password,
              hintText: '•••••••••••••',
            ),
            32.hs,
            BlocConsumer<UserProfileCubit, UserProfileState>(
              listener: (context, state) {
                if (state is UserProfileLoaded) {
                  context.pop();
                  customSnackBar(
                    context: context,
                    message: LocaleKeys.password_changed.tr(),
                    type: AnimatedSnackBarType.success,
                  );
                }
                if (state is UserProfileError) {
                  customSnackBar(
                    context: context,
                    message: state.failure,
                    type: AnimatedSnackBarType.error,
                  );
                }
              },
              builder: (context, state) {
                return CustomButton(
                  isLoading: state is UserProfileLoading,
                  title: LocaleKeys.save.tr(),
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      context.read<UserProfileCubit>().changePassword(
                        password: passwordController.text,
                        newPassword: newPasswordController.text,
                      );
                    } else {
                      setState(
                        () => autovalidateMode = AutovalidateMode.always,
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
