import 'package:taxi_app/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.onTap,
    this.validator,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.inputFormatters,
    this.prefixIcon,
    this.readOnly = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: AppStyles.textRegular14,
      textAlign: textAlign,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
