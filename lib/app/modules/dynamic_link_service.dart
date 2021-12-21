import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/modules/onboarding_screen/views/onboarding_screen_view.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/modules/recommendation_screen/views/recommended_connection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/views/home_view.dart';

class DynamicLinkService {
  APICALLS apicalls = APICALLS();
  Future<void> retrieveDynamicLink({required BuildContext context}) async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;
      print('\n\n deepLink ::: ${deepLink.toString()}');
      if (deepLink != null) {
        print(deepLink);
        if (deepLink.queryParameters.containsKey("id")) {
          var id = deepLink.queryParameters["id"];
          //navigate to a specific page andparse the id
          print('the dynamic link id is $id');
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String? token;
          bool? loggedOut;

          token = prefs.getString('token');

          loggedOut = prefs.getBool("logged_out");
          prefs.setString("dynamicLink", id!);
          // state;
          print("This is the token---splashs screen");
          //stop progress bar
          Get.back();

          if (token != null && loggedOut != null && !loggedOut && id != null) {
            if (id != null) {
              Get.to(RecommendedScreenView(connectionID: id));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('No data Found!')));
            }
          } else if (token != null && loggedOut != null && loggedOut) {
            Get.offAll(AuthScreenView());
          } else if (token == null) {
            Get.offAll(OnboardingScreenView());
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('No data Found')));
          }
        }
      } else {
        // navigateUser(context, state);
      }
    } catch (e) {
      print(e);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      print('Dynamic Link Page \n\n deepLink ::: ${dynamicLink?.link}');
      // final PendingDynamicLinkData? data =
      //     await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = dynamicLink?.link;
      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey("id")) {
          var id = deepLink.queryParameters["id"];
          print('Dynamic Link page the dynamic link id is $id');
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Center(child: pluhgProgress()),
          );
          //navigate to a specific page andparse the id
          // Future.delayed(Duration(milliseconds: 5000), () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String? token;
          bool? loggedOut;

          token = prefs.getString('token');

          loggedOut = prefs.getBool("logged_out");
          // state;
          //stop progress bar
          Get.back();
          if (token != null && loggedOut != null && !loggedOut && id != null) {
            if (id != null) {
              Get.to(RecommendedScreenView(connectionID: id));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('No data Found!')));
            }
          } else if (token != null && loggedOut != null && loggedOut) {
            Get.offAll(AuthScreenView());
          } else if (token == null) {
            Get.offAll(OnboardingScreenView());
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('No data Found')));
          }
        }
      }
    }, onError: (error) async {
      print('error is $error');
    });
  }
}
