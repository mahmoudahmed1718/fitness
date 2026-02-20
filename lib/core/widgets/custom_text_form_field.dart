import 'package:fitness/core/utlis/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.icon,
    this.onSaved,
    this.isObscure,
    this.controller,
  });
  final bool? isObscure;
  final String hintText;
  final TextInputType textInputType;
  final Widget? icon;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure == null ? false : isObscure!,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: icon,

        hintText: hintText,
        hintStyle: TextStyles.bold13.copyWith(color: Color(0XFF949D9E)),
        filled: true,
        fillColor: Color(0XFFF9FAFA),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(width: 1, color: Color(0XFFE6E9E9)),
    );
  }
}
