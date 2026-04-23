import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/functions/validators.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/models/location_model.dart';
import 'package:taxi_app/core/routing/app_routes.dart';
import 'package:taxi_app/core/services/location_service.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_rich_text.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field_password.dart';
import 'package:taxi_app/core/widgets/label_text.dart';
import 'package:taxi_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taxi_app/features/auth/presentation/widgets/car_info_section.dart';
import 'package:taxi_app/features/auth/presentation/widgets/profile_image_picker.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key, required this.role});

  final String role;

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  File? file;
  LocationModel? location;
  late TextEditingController emailController,
      passwordController,
      nameController,
      phoneController,
      plateController,
      modelController,
      colorController,
      locationController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    plateController = TextEditingController();
    modelController = TextEditingController();
    colorController = TextEditingController();
    locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    plateController.dispose();
    modelController.dispose();
    colorController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.hs,
            Align(
              alignment: Alignment.center,
              child: ProfileImagePicker(
                file: file,
                onPick: (file) => setState(() => this.file = file),
              ),
            ),
            32.hs,
            LabelText(text: LocaleKeys.full_name.tr()),
            6.hs,
            CustomTextFormField(
              controller: nameController,
              validator: Validators.name,
              keyboardType: TextInputType.name,
              hintText: 'Adham Amin',
              suffixIcon: Icon(Icons.person_2_outlined),
            ),
            16.hs,
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
            LabelText(text: LocaleKeys.phone_number.tr()),
            6.hs,
            CustomTextFormField(
              controller: phoneController,
              validator: Validators.phone,
              keyboardType: TextInputType.phone,
              hintText: '+201000000000',
              suffixIcon: Icon(Icons.phone_android_outlined),
            ),
            16.hs,
            LabelText(text: LocaleKeys.password.tr()),
            6.hs,
            CustomTextFormFieldPassword(
              controller: passwordController,
              validator: Validators.password,
              hintText: '•••••••••••••',
            ),
            widget.role == 'driver'
                ? CarInfoSection(
                    carColorController: colorController,
                    carModelController: modelController,
                    carPlateController: plateController,
                    locationController: locationController,
                    onPressed: () async {
                      final loc = await LocationServices().getCurrentLocation();
                      setState(() {
                        location = loc;
                        locationController.text = loc.fullAddress;
                      });
                    },
                  )
                : Container(),
            32.hs,
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoaded) {
                  state.user.role == 'user'
                      ? context.go(AppRoutes.userMain)
                      : context.go(AppRoutes.driverMain);
                }
                if (state is AuthError) {
                  customSnackBar(
                    context: context,
                    message: state.message,
                    type: AnimatedSnackBarType.error,
                  );
                }
              },
              builder: (context, state) {
                return CustomButton(
                  isLoading: state is AuthLoading,
                  title: LocaleKeys.register.tr(),
                  onTap: () {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      setState(
                        () => autovalidateMode = AutovalidateMode.always,
                      );
                      return;
                    }
                    _formKey.currentState!.save();

                    if (file == null) {
                      customSnackBar(
                        context: context,
                        message: LocaleKeys.please_select_profile_image.tr(),
                        type: AnimatedSnackBarType.error,
                      );
                      return;
                    }

                    if (widget.role == 'user') {
                      context.read<AuthCubit>().userRegister(
                        image: file!,
                        fullName: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phone: phoneController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      return;
                    }

                    if (location == null) {
                      customSnackBar(
                        context: context,
                        message: LocaleKeys.please_select_location.tr(),
                        type: AnimatedSnackBarType.error,
                      );
                      return;
                    }

                    context.read<AuthCubit>().driverRegister(
                      image: file!,
                      fullName: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      password: passwordController.text.trim(),
                      carPlateNumber: plateController.text.trim(),
                      carModel: modelController.text.trim(),
                      carColor: colorController.text.trim(),
                      lat: location!.lat.toDouble(),
                      lng: location!.lng.toDouble(),
                    );
                  },
                );
              },
            ),
            24.hs,
            Center(
              child: CustomRichText(
                text: LocaleKeys.already_have_an_account.tr(),
                linkText: LocaleKeys.login.tr(),
                onTap: () => context.pushReplacement(AppRoutes.login),
              ),
            ),
            48.hs,
          ],
        ),
      ),
    );
  }
}
