import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms_project/features/features.dart';

import '../../../../core/utils/utils.dart';

class HomeSplash extends StatefulWidget {
  const HomeSplash({Key? key}) : super(key: key);

  @override
  State<HomeSplash> createState() => _HomeSplashState();
}

class _HomeSplashState extends State<HomeSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  String? userId;
  String? imei;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..forward()
      ..repeat(reverse: true);
    getUserData();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.grey[100],
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(AppColor.primaryColor),
                      ),
                    ),
                    elevation: 0,
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Container(
                        width: 200,
                        height: 200,
                        padding: EdgeInsets.all(
                          18 * animationController.value,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AppImages.launcherLogo),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future getUserData() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final deviceId =
        androidInfo.fingerprint.replaceAll('/', '').replaceAll(':', '');
    final headers = {'Accept-Language': 'application/json'};
    final request = http.Request(
      'GET',
      Uri.parse('${AppStrings.baseUrl}user/$deviceId/imei'),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final decodedData = json.decode(responseData);
      userId = "${decodedData['id']}";
      imei = "${decodedData['imei']}";
      await getBankList();
      return response;
    } else {
      final headers = {'Accept-Language': 'application/json'};
      final sendUserData = http.MultipartRequest(
        "POST",
        Uri.parse('${AppStrings.baseUrl}user'),
      );
      sendUserData.fields.addAll({
        "firstName": androidInfo.device,
        "lastName": androidInfo.model,
        "imei": deviceId,
      });
      sendUserData.headers.addAll(headers);
      http.StreamedResponse sendUserDataResponse = await sendUserData.send();
      if (sendUserDataResponse.statusCode == 201) {
        await getUserData();
      } else {
        debugPrint("${sendUserDataResponse.statusCode}");
        debugPrint('${AppStrings.baseUrl}user');
        debugPrint("${sendUserData.fields}");
        debugPrint("${sendUserData.headers}");
        debugPrint(await sendUserDataResponse.stream.bytesToString());
        debugPrint('خطـــــــــــــــــــــــــــــــــا');
        debugPrint(sendUserDataResponse.reasonPhrase);
      }
    }
  }

  Future getBankList() async {
    final dio = Dio();
    var response = await dio.get(
      '${AppStrings.baseUrl}alert-number/country/OMAN',
    );
    if (response.statusCode == 202) {
      var bankNumber = <String>[];
      for (int i = 0; i < response.data.length; i++) {
        bankNumber.add(response.data[i]['alertHead']);
      }
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
          arguments: MainScreenParams(
            id: userId!,
            imei: imei!,
            bankNumber: bankNumber,
          ),
        );
      }
    } else {
      debugPrint('errrrrrrrrrrrrrrror');
    }
  }
}
