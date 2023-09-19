import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyboardType ?? TextInputType.text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      cursorColor: const Color(AppColor.primaryColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(AppColor.primaryColor),
          fontSize: 12,
        ),
        border: InputBorder.none,
        focusedBorder: border(context),
        enabledBorder: border(context),
      ),
    );
  }

  InputBorder border(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue.withOpacity(0.6),
        width: 1,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }
}
