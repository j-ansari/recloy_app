import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_auth/native_auth.dart';
import 'package:sms_project/core/core.dart';
import 'package:sms_project/core/utils/utils.dart';

import '../../../grant_permission/grant_permission_screen.dart';
import '../../../home_splash/presentation/screen/home_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _authenticate().then((_) async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (mounted) {
        if (connectivityResult == ConnectivityResult.none) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => NoInternet(
              child: Builder(
                builder: (context) {
                  if (UtilPreferences.getBool(Preferences.firstLoginUser) ==
                      null) {
                    return const GrantPermissionScreen();
                  } else {
                    return const HomeSplash();
                  }
                },
              ),
            ),
          );
        } else {
          if (UtilPreferences.getBool(Preferences.firstLoginUser) == null) {
            Navigator.pushReplacementNamed(context, Routes.grantPermission);
          } else {
            Navigator.pushReplacementNamed(context, Routes.homeSplash);
          }
        }
      }
    });
    super.initState();
  }

  Future<void> _authenticate() async {
    bool? authenticate;
    try {
      final checkAuthenticate = await Auth.isAuthenticate();
      authenticate = checkAuthenticate.isAuthenticated;
    } on PlatformException catch (e) {
      debugPrint("$e");
      return;
    }
    if (authenticate != true) {
      exit(0);
    }
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
