import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? width;
  final bool isDisable;
  final VoidCallback onClick;

  const AppButton({
    Key? key,
    required this.title,
    this.width,
    this.isDisable = false,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 35,
      minWidth: width ?? double.infinity,
      color: isDisable
          ? Colors.blue.withOpacity(0.4)
          : const Color(AppColor.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: isDisable ? () {} : onClick,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isDisable ? Colors.white.withOpacity(0.5) : Colors.white,
        ),
      ),
    );
  }
}
