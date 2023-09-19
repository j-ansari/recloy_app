import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'core/core.dart';
import 'core/utils/utils.dart';
import 'features/filter_sms/presentation/screen/filter_sms_screen.dart';
import 'features/home_default/presentation/screen/home_default_screen.dart';
import 'features/profile_screen/screen/profile_screen.dart';

class MainScreenParams {
  final String id;
  final String imei;
  final List<String> bankNumber;

  MainScreenParams({
    required this.id,
    required this.imei,
    required this.bankNumber,
  });
}

class MainScreen extends StatefulWidget {
  final MainScreenParams params;

  const MainScreen({Key? key, required this.params}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => exitDialog(context: context, size: size),
      child: SafeArea(
        child: Scaffold(
          appBar: selectedIndex != 1
              ? MyAppBar(
                  context: context,
                  label: AppStrings.appName,
                  isBackRequired: false,
                  index: selectedIndex,
                  onTap: () {},
                )
              : null,
          body: IndexedStack(
            index: selectedIndex,
            children: [
              const ProfileScreen(),
              HomeScreen(
                id: widget.params.id,
                bankNumber: widget.params.bankNumber,
                imei: widget.params.imei,
              ),
              FilterSmsScreen(id: widget.params.id),
            ],
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: selectedIndex,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            backgroundColor: Colors.grey[100],
            curve: Curves.easeIn,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.person),
                title: const Text(AppStrings.profile),
                activeColor: const Color(AppColor.primaryColor),
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.apps),
                title: const Text(AppStrings.home),
                activeColor: const Color(AppColor.primaryColor),
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.filter_alt_outlined),
                title: const Text(AppStrings.filter),
                activeColor: const Color(AppColor.primaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
