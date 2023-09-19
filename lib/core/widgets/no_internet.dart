import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../core.dart';
import '../utils/utils.dart';

class NoInternet extends StatelessWidget {
  final Widget child;

  const NoInternet({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 50,
            color: Color(AppColor.primaryColor),
          ),
          const SizedBox(height: 15),
          const Text(
            'Your device is not connected to the Internet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please check your connection',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          AppButton(
            title: 'retry',
            onClick: () async {
              final connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.none) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NoInternet(child: child);
                  },
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => child,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
