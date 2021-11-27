import 'dart:async';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/AuthScreen/views/auth_screen_view.dart';
import 'package:plug/app/modules/OnboardingScreen/views/onboarding_screen_view.dart';
import 'package:plug/app/modules/dynamiclinkservice.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/screens/Recommended_Connection_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController
  APICALLS apicalls = APICALLS();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}

  getInit() {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    _dynamicLinkService.retrieveDynamicLink(context: Get.context!);

    Future.delayed(Duration(milliseconds: 5000), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // String? deviceTokenString = await FirebaseMessaging.instance.getToken();
      // print("DEVICE TOEKKKKKK- $deviceTokenString");
      String token = '';

      bool? loggedOut;
      bool dynamicLink = false;
      String dynamicLinks = '', emailAdress = '', phoneNumber = '';
      dynamic data;

      loggedOut = prefs.getBool("logged_out");

      if (prefs.getString('token').toString().isNotEmpty &&
          prefs.getString('dynamicLink') != null) {
        token = prefs.getString('token')!;
        dynamicLinks = prefs.getString('dynamicLink')!;
        emailAdress = prefs.getString("emailAddress")!;
        phoneNumber = prefs.getString("phoneNumber")!;
      }

      print("This is the token---splashs screen");
      if (prefs.getString('token').toString().isNotEmpty &&
          dynamicLinks.isNotEmpty) {
        var waitingConnections = await apicalls.getWaitingConnections(
            token: token,
            contact: phoneNumber.isEmpty ? emailAdress : phoneNumber);
        List waitingConns = waitingConnections['data'] == null
            ? []
            : waitingConnections['data'];
        if (waitingConns.length != 0) {
          dynamicLink = true;

          data = waitingConns.singleWhere(
            (element) => element['_id'] == dynamicLinks,
            orElse: () => null,
          );
        }
      }

      // if (prefs.getString('token') != null) {
      //   await apicalls.getProfile(
      //       token: prefs.get("token").toString(),
      //       userID: prefs.get("userID").toString());
      // }
      Get.offAll(() => loggedOut == true
          ? AuthScreenView()
          : prefs.getString('token') == null
              ? OnboardingScreenView()
              : !dynamicLink
                  ? HomeView(
                      index: 1,
                    )
                  : RecommendedConnectionScreen(
                      data: data,
                    ));
    });
  }
}
