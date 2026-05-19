import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/widgets/custom_button.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/core/widgets/label_text.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/driver/settings/presentation/cubit/settings_cubit.dart';

class UpdateVehicleViewBody extends StatefulWidget {
  const UpdateVehicleViewBody({super.key});

  @override
  State<UpdateVehicleViewBody> createState() => _UpdateVehicleViewBodyState();
}

class _UpdateVehicleViewBodyState extends State<UpdateVehicleViewBody> {

  late TextEditingController carModelController;
  late TextEditingController carColorController;
  late TextEditingController carPlateController;

  @override
  void initState() {
    var driver = Prefs.getUser()!;
    carModelController = TextEditingController(text: driver.carModel);
    carColorController = TextEditingController(text: driver.carColor);
    carPlateController = TextEditingController(text: driver.carPlateNumber);
    super.initState();
  }

  @override
  void dispose() {
    carModelController.dispose();
    carColorController.dispose();
    carPlateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.hs,
          LabelText(text: LocaleKeys.car_model.tr()),
          6.hs,
          CustomTextFormField(
            controller: carModelController,
            validator: (value) =>
                value!.isEmpty ? LocaleKeys.car_model_hint.tr() : null,
            keyboardType: TextInputType.text,
            hintText: 'Toyota',
            suffixIcon: Icon(Icons.car_repair_outlined),
          ),
          16.hs,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(text: LocaleKeys.car_color.tr()),
                    6.hs,
                    CustomTextFormField(
                      controller: carColorController,
                      validator: (value) =>
                          value!.isEmpty ? LocaleKeys.car_color_hint.tr() : null,
                      keyboardType: TextInputType.text,
                      hintText: 'Red',
                      suffixIcon: Icon(Icons.color_lens_outlined),
                    ),
                  ],
                ),
              ),
              12.ws,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(text: LocaleKeys.car_plate_number.tr()),
                    6.hs,
                    CustomTextFormField(
                      controller: carPlateController,
                      validator: (value) => value!.isEmpty
                          ? LocaleKeys.car_plate_number_hint.tr()
                          : null,
                      keyboardType: TextInputType.text,
                      hintText: 'ABC-123',
                      suffixIcon: Icon(Icons.numbers_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
          32.hs,
          BlocConsumer<SettingsCubit, SettingsState>(
              listener: (context, state) {
                if (state is SettingsLoaded) {
                  customSnackBar(
                    context: context,
                    message: LocaleKeys.update_vehicle.tr(),
                    type: AnimatedSnackBarType.success,
                  );
                  context.pop(true);
                }
                if (state is SettingsError) {
                  customSnackBar(
                    context: context,
                    message: state.failure,
                    type: AnimatedSnackBarType.error,
                  );
                }
              },
              builder: (context, state) {
                return CustomButton(
                  isLoading: state is SettingsLoading,
                  onTap: () async {
                    if (carColorController.text != Prefs.getUser()!.carColor ||
                          carModelController.text != Prefs.getUser()!.carModel ||
                          carPlateController.text != Prefs.getUser()!.carPlateNumber) {
                        context.read<SettingsCubit>().updateDriverProfile(
                          driver: UserInfoModel(
                            carColor: carColorController.text,
                            carModel: carModelController.text,
                            carPlateNumber: carPlateController.text,
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
                     
      
                  },
                  title: LocaleKeys.save.tr(),
                );
              },
              )
            
        ],
      ),
    );
  }
}