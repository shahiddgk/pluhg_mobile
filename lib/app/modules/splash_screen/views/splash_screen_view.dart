import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  final splashController = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff000BFF),
        body: FutureBuilder(
            future: splashController.getInit(),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  SvgPicture.asset("assets/svg/splash_background.svg"),
                  Center(child: SvgPicture.asset("assets/svg/logo_text.svg")),
                ],
              );
            }));
  }
}
