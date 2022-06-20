import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/modules/onboarding_screen/views/onboarding_screen_view.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/progressbar.dart';
import '../../dynamic_link_service.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}

  //load splash screen for 2 second and redirect to proper page
  getInit() async {
    // Get.offAll(this._getScreen(user, isFirstRun));
    retrieveDynamicLink();
  }

  Future<void> retrieveDynamicLink() async {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    _dynamicLinkService.retrieveDynamicLink(deepCallBack: (deeplink, activate) {
      _handleDeepLink(deepLink: deeplink, activateDialog: activate);
    });
  }

  _handleDeepLink({Uri? deepLink, bool? activateDialog}) async {
    User user = await UserState.get();
    SharedPreferences storage = await SharedPreferences.getInstance();
    bool? isFirstRun = storage.getBool(PREF_IS_FIRST_APP_RUN);

    if (deepLink == null ||
        deepLink.queryParameters.containsKey("id") == false) {
      Get.offAll(_getScreen(user, isFirstRun));
      return;
    }

    String? id = deepLink?.queryParameters["id"]!;
    print('[_handleDeepLink] the dynamic link id is $id');

    user.setDynamicLink(id!);
    await UserState.store(user);

    if (activateDialog ?? false) {
      showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => Center(child: pluhgProgress()),
      );
    }

    print(
        "[_handleDeepLink] navigate to a specific page and parse the ID[$id]");
    //stop progress bar
    Get.back();
    if (user.token.isNotEmpty && user.isAuthenticated) {
      if (id!.isEmpty) {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text('No data Found!')));
      } else {
        Get.to(
            () => HomeView(index: 1.obs) //WaitingScreenView(connectionID: id)
            );
      }
    } else if (user.token.isNotEmpty && user.isAuthenticated == false) {
      Get.offAll(() => AuthScreenView());
    } else if (user.token.isEmpty) {
      Get.offAll(() => OnboardingScreenView());
    } else {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text('No data Found')));
    }
  }

  // if isAuthenticated is true and token is false user is new so will be directed to boarding screen
  // else if isAuthenticated is false just then AuthScreen
  // else if both are true then Homepage
  dynamic _getScreen(User user, bool? isFirstRun) {
    print("[Splash::_getScreen] user [${user.toString()}]");
    if (isFirstRun == null || isFirstRun) {
      return OnboardingScreenView();
    }

    if (user.isAuthenticated == false) {
      return AuthScreenView();
    }

    //if((user.email != null  && user.email.isNotEmpty && user.name != null && user.name.isNotEmpty) || (user.phone != null  && user.phone.isNotEmpty && user.name != null && user.name.isNotEmpty))

    // registered user
    return HomeView(index: 1.obs);
  }
}
