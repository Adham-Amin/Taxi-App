import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/functions/validators.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field_password.dart';
import 'package:taxi_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taxi_app/core/widgets/label_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController emailController, passwordController;

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelText(text: LocaleKeys.email_address.tr()),
          6.hs,
          CustomTextFormField(
            controller: emailController,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
            hintText: 'adham@example.com',
            suffixIcon: Icon(Icons.email_outlined),
          ),
          16.hs,
          LabelText(text: LocaleKeys.password.tr()),
          6.hs,
          CustomTextFormFieldPassword(
            controller: passwordController,
            validator: (value) =>
                value!.isEmpty ? LocaleKeys.enter_your_password.tr() : null,
            hintText: '••••••••••••',
          ),
          32.hs,
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                customSnackBar(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.error,
                );
              }
              if (state is AuthLoaded) {
                state.user.role == 'user'
                    ? context.go(AppRoutes.userMain)
                    : customSnackBar(
                        context: context,
                        message: 'Driver logged in successfully',
                        type: AnimatedSnackBarType.success,
                      );
              }
            },
            builder: (context, state) {
              return CustomButton(
                isLoading: state is AuthLoading,
                title: LocaleKeys.login.tr(),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    context.read<AuthCubit>().login(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  } else {
                    setState(() => autovalidateMode = AutovalidateMode.always);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
