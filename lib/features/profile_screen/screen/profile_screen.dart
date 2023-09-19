import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/core.dart';
import '../../../core/utils/utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: const Color(AppColor.primaryColor),
          height: 1,
        ),
        tabItems(
          title: 'Privacy Policy',
          icon: Icons.policy,
          onTap: () async {
            await launchUrlString(
              AppStrings.policyLink,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: const Color(AppColor.primaryColor),
          height: 1,
        ),
        tabItems(
          title: 'exit app',
          icon: Icons.exit_to_app_outlined,
          onTap: () async => await exitDialog(context: context, size: size),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: const Color(AppColor.primaryColor),
          height: 1,
        ),
      ],
    );
  }

  Widget tabItems({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(AppColor.primaryColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(AppColor.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
