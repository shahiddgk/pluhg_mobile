import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';

import '../controllers/onboarding_screen_controller.dart';
import 'onboarding_intro_screen_view.dart';

class OnboardingScreenView extends GetView<OnboardingScreenController> {
  final controller1 = Get.put(OnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000BFF),
      body: Center(
        child: Column(
          children: [
            // SizedBox(height: 120.h),
            Spacer(flex: 2),
            SvgPicture.asset(
              "assets/svg/splash_logo.svg",
              width: 147.65.w,
              height: 178.64.h,
            ),
            Spacer(flex: 1),
            // SizedBox(
            //   height: 108.h,
            // ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Easily Connect People!\n",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  height: 1.67,
                  fontWeight: FontWeight.w600,
                ),
                children: [TextSpan(text: "( You are the Pluhg! )")],
              ),
            ),
            //SizedBox(height: 80.01.h),
            Spacer(flex: 1),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 261.w),
              child: PluhgButton(
                text: "Get Started",
                textColor: pluhgColour,
                color: Colors.white,
                onPressed: () => Get.offAll(OnboardingScreen2View()),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
