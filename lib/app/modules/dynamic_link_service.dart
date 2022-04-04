import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/modules/onboarding_screen/views/onboarding_screen_view.dart';
import 'package:plug/app/modules/recommendation_screen/views/recommended_connection_screen.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/progressbar.dart';

class DynamicLinkService {
  Future<void> retrieveDynamicLink({required BuildContext context}) async {
    try {
      final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      print('---------------------->${deepLink.toString()}');

      this._handleDeepLink(context, deepLink);
    } catch (e) {
      print(e);
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      // final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = dynamicLink?.link;

      print('---------------------->${deepLink.toString()}');

      this._handleDeepLink(context, deepLink, true);
    }, onError: (error) async {
      print('error is $error');
    });
  }

  Future<void> _handleDeepLink(BuildContext context, Uri? deepLink, [bool activateDialog = false]) async {
    print('\n\n[_handleDeepLink] deepLink ::: ${deepLink.toString()}');
    if (deepLink == null || deepLink.queryParameters.containsKey("id") == false) {
      return;
    }

    String id = deepLink.queryParameters["id"]!;
    print('[_handleDeepLink] the dynamic link id is $id');

    if (activateDialog) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(child: pluhgProgress()),
      );
    }

    User user = await UserState.get()
      ..setDynamicLink(id);
    await UserState.store(user);

    //navigate to a specific page and parse the id
    // state;
    print("[_handleDeepLink] navigate to a specific page and parse the ID[$id]");
    //stop progress bar
    Get.back();
    if (user.token.isNotEmpty && user.isAuthenticated) {
      if (id.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No data Found!')));
      } else {
        Get.to(() => RecommendedScreenView(connectionID: id));
      }
    } else if (user.token.isNotEmpty && user.isAuthenticated == false) {
      Get.offAll(() => AuthScreenView());
    } else if (user.token.isEmpty) {
      Get.offAll(() => OnboardingScreenView());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No data Found')));
    }
  }
}
