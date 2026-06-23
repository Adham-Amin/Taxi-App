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
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/core/widgets/label_text.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taxi_app/features/auth/presentation/widgets/car_info_section.dart';
import 'package:taxi_app/features/auth/presentation/widgets/profile_image_picker.dart';
import 'package:taxi_app/features/intro/welcome/data/model/user_type_enum.dart';
import 'package:taxi_app/features/intro/welcome/presentation/widgets/role_selector.dart';

class CompleteProfileViewBody extends StatefulWidget {
  const CompleteProfileViewBody({super.key, required this.googleData});

  final UserInfoModel googleData;

  @override
  State<CompleteProfileViewBody> createState() =>
      _CompleteProfileViewBodyState();
}

class _CompleteProfileViewBodyState extends State<CompleteProfileViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  UserTypeEnum role = UserTypeEnum.user;
  File? file;
  LocationModel? location;

  late TextEditingController nameController,
      emailController,
      phoneController,
      plateController,
      modelController,
      colorController,
      locationController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.googleData.name ?? '');
    emailController = TextEditingController(text: widget.googleData.email ?? '');
    phoneController = TextEditingController();
    plateController = TextEditingController();
    modelController = TextEditingController();
    colorController = TextEditingController();
    locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    plateController.dispose();
    modelController.dispose();
    colorController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() => autovalidateMode = AutovalidateMode.always);
      return;
    }
    _formKey.currentState!.save();

    final cubit = context.read<AuthCubit>();
    final googlePhotoUrl = widget.googleData.image;

    if (role == UserTypeEnum.user) {
      cubit.completeGoogleUserProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        googlePhotoUrl: googlePhotoUrl,
        image: file,
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

    cubit.completeGoogleDriverProfile(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      googlePhotoUrl: googlePhotoUrl,
      image: file,
      carModel: modelController.text.trim(),
      carColor: colorController.text.trim(),
      carPlateNumber: plateController.text.trim(),
      lat: location!.lat.toDouble(),
      lng: location!.lng.toDouble(),
    );
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
                onPick: (picked) => setState(() => file = picked),
              ),
            ),
            32.hs,
            RoleSelector(onTap: (value) => setState(() => role = value)),
            24.hs,
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
              readOnly: true,
              hintText: '',
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
            if (role == UserTypeEnum.driver)
              CarInfoSection(
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
              ),
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
                  title: LocaleKeys.save.tr(),
                  onTap: _submit,
                );
              },
            ),
            48.hs,
          ],
        ),
      ),
    );
  }
}
