import 'dart:async';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/modules/onboarding_screen/views/onboarding_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}

  //load splash screen for 2 second and redirect to proper page

  getInit() {
    Future.delayed(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = '';
      bool? loggedOut;

      loggedOut = prefs.getBool("logged_out");
      token = prefs.getString('token') ?? "";
      //if logged_out is false and token is false user is new so will be directed to
      // boarding screen else if token is empty just then AuthScreen or both are true
      // then homepage
      Get.offAll(() => loggedOut == true
          ? AuthScreenView()
          : token.isEmpty
              ? OnboardingScreenView()
              : HomeView(
                  index: 1.obs,
                ));
    });
  }
}
