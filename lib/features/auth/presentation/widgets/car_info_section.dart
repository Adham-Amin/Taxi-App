import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/core/functions/extentions.dart';
import 'package:taxi_app/core/lang/locale_keys.g.dart';
import 'package:taxi_app/core/utils/app_colors.dart';
import 'package:taxi_app/core/widgets/custom_text_form_field.dart';
import 'package:taxi_app/core/widgets/label_text.dart';

class CarInfoSection extends StatelessWidget {
  const CarInfoSection({
    super.key,
    required this.locationController,
    required this.carModelController,
    required this.carColorController,
    required this.carPlateController,
    this.onPressed,
  });

  final TextEditingController locationController,
      carModelController,
      carColorController,
      carPlateController;

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.hs,
        LabelText(text: LocaleKeys.location.tr()),
        6.hs,
        CustomTextFormField(
          hintText: "Location",
          controller: locationController,
          readOnly: true,
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.location_on_outlined, color: AppColors.lightGreen),
          ),
        ),
        16.hs,
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
      ],
    );
  }
}
