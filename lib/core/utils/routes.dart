import 'package:flutter/material.dart';

import '../../features/features.dart';
import '../../features/grant_permission/grant_permission_screen.dart';
import '../../features/home_splash/presentation/screen/home_splash.dart';

class Routes {
  static final Routes _instance = Routes._internal();
  factory Routes() => _instance;
  Routes._internal();

  static const String home = "/home";
  static const String homeSplash = "/homeSplash";
  static const String grantPermission = "/grantPermission";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return screenRouting(
          MainScreen(params: settings.arguments as MainScreenParams),
        );

      case homeSplash:
        return screenRouting(const HomeSplash());

      case grantPermission:
        return screenRouting(const GrantPermissionScreen());

      default:
        return screenRouting(
          const Scaffold(
            body: Center(
              child: Text('خطا'),
            ),
          ),
        );
    }
  }

  PageRouteBuilder screenRouting(Widget screen) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
    );
  }
}
