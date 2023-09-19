import 'package:flutter/material.dart';

import '../utils/utils.dart';

class MyAppBar extends AppBar {
  final BuildContext context;
  final String label;
  final bool isBackRequired;
  final int index;
  final VoidCallback onTap;

  MyAppBar({
    super.key,
    required this.context,
    required this.label,
    this.isBackRequired = true,
    required this.index,
    required this.onTap,
  }) : super(
          backgroundColor: Colors.grey[100],
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(AppColor.primaryColor),
            ),
          ),
          elevation: 0,
          actions: [
            index == 1
                ? IconButton(
                    onPressed: onTap,
                    icon: const Icon(
                      Icons.refresh,
                      color: Color(AppColor.primaryColor),
                      size: 30,
                    ),
                  )
                : const SizedBox(),
          ],
          leading: isBackRequired
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                )
              : const SizedBox(),
        );
}
