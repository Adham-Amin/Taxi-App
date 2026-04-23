// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/functions/image_uploader.dart';
import 'package:taxi_app/core/functions/validators.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/core/widgets/label_text.dart';
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
  late TextEditingController nameController, phoneController;

  @override
  void initState() {
    var user = Prefs.getUser()!;
    nameController = TextEditingController(text: user.name);
    phoneController = TextEditingController(text: user.phone);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
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
          LabelText(text: LocaleKeys.phone_number.tr()),
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
                  message: LocaleKeys.profile_updated.tr(),
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
                        phone: phoneController.text,
                      ),
                    );
                  } else if (file == null) {
                    if (nameController.text != Prefs.getUser()!.name ||
                        phoneController.text != Prefs.getUser()!.phone) {
                      context.read<UserProfileCubit>().updateUserProfile(
                        profileUserModel: UserInfoModel(
                          name: nameController.text,
                          phone: phoneController.text,
                        ),
                      );
                    } else {
                      customSnackBar(
                        context: context,
                        message: LocaleKeys.please_change_at_least_one_field
                            .tr(),
                        type: AnimatedSnackBarType.warning,
                      );
                      setState(() {});
                    }
                  } else {
                    customSnackBar(
                      context: context,
                      message: LocaleKeys.please_fill_at_least_one_field.tr(),
                      type: AnimatedSnackBarType.warning,
                    );
                  }
                },
                title: LocaleKeys.save.tr(),
              );
            },
          ),
        ],
      ),
    );
  }
}
