// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/functions/image_uploader.dart';
import 'package:taxi_app/core/functions/validators.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/presentation/widgets/profile_image_picker.dart';
import 'package:taxi_app/features/user/features/profile/presentation/cubit/profile_cubit.dart';

class UserUpdateProfileViewBody extends StatefulWidget {
  const UserUpdateProfileViewBody({super.key});

  @override
  State<UserUpdateProfileViewBody> createState() =>
      _UserUpdateProfileViewBodyState();
}

class _UserUpdateProfileViewBodyState extends State<UserUpdateProfileViewBody> {
  File? file;
  late TextEditingController nameController, emailController, phoneController;

  @override
  void initState() {
    var user = Prefs.getUser()!;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
          Text(
            'FULL NAME',
            style: AppStyles.textRegular10.copyWith(
              color: AppColors.accent,
              letterSpacing: 2,
            ),
          ),
          6.hs,
          CustomTextFormField(
            controller: nameController,
            validator: Validators.name,
            keyboardType: TextInputType.name,
            hintText: 'Adham Amin',
            suffixIcon: Icon(Icons.person_2_outlined),
          ),
          16.hs,
          Text(
            'EMAIL ADDRESS',
            style: AppStyles.textRegular10.copyWith(
              color: AppColors.accent,
              letterSpacing: 2,
            ),
          ),
          6.hs,
          CustomTextFormField(
            controller: emailController,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
            hintText: 'adham@example.com',
            suffixIcon: Icon(Icons.email_outlined),
          ),
          16.hs,
          Text(
            'Phone Number',
            style: AppStyles.textRegular10.copyWith(
              color: AppColors.accent,
              letterSpacing: 2,
            ),
          ),
          6.hs,
          CustomTextFormField(
            controller: phoneController,
            validator: Validators.phone,
            keyboardType: TextInputType.phone,
            hintText: '+201000000000',
            suffixIcon: Icon(Icons.phone_android_outlined),
          ),
          32.hs,
          BlocConsumer<UserProfileCubit, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileLoaded) {
                customSnackBar(
                  context: context,
                  message: 'Profile Updated Successfully',
                  type: AnimatedSnackBarType.success,
                );
                context.pop(true);
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
                onTap: () async {
                  if (file != null) {
                    var imageUrl = await uploadImageToCloudinary(file!);
                    context.read<UserProfileCubit>().updateUserProfile(
                      profileUserModel: UserInfoModel(
                        image: imageUrl,
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      ),
                    );
                  } else if (file == null) {
                    context.read<UserProfileCubit>().updateUserProfile(
                      profileUserModel: UserInfoModel(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      ),
                    );
                  } else {
                    customSnackBar(
                      context: context,
                      message: 'Please Fill at least one field',
                      type: AnimatedSnackBarType.warning,
                    );
                  }
                },
                title: 'Save',
              );
            },
          ),
        ],
      ),
    );
  }
}
