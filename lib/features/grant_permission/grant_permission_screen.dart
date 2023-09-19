import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/utils/utils.dart';

class GrantPermissionScreen extends StatelessWidget {
  const GrantPermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(AppColor.primaryColor),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'SMS Permission',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'App   collects   SMS   information   to process   your   transactional SMS automatically into your expenses.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'This   helps   you  to  manage your  finances  without spending time on manual tracking.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No personal SMS are processed. This information is never shared to any third party.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'By continuing, you agree to our ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await launchUrlString(
                            AppStrings.policyLink,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: const Text(
                          'Privacy Policy ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 40,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () async {
                      final permission = await Permission.sms.request();
                      if (permission.isGranted) {
                        await UtilPreferences.setBool(
                          Preferences.firstReadSms,
                          true,
                        ).then((value) {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.homeSplash,
                          );
                        });
                        return;
                      }
                      if (permission.isPermanentlyDenied) {
                        permissionResultDialog(context);
                      }
                    },
                    child: const Text(
                      'Agree, Grant Permission',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(AppColor.primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void permissionResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                'This app needs READ SMS PERMISSION to read messages to provide its services',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(AppColor.primaryColor),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please grant this permission to the app',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(AppColor.primaryColor),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      height: 40,
                      color: const Color(AppColor.primaryColor),
                      onPressed: () async => await openAppSettings(),
                      child: const Text(
                        'Grant Permission',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: MaterialButton(
                      height: 40,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(AppColor.primaryColor),
                          width: 1,
                        ),
                      ),
                      color: Colors.white,
                      onPressed: () => exit(0),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(AppColor.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
