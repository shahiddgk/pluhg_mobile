import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';

import '../controllers/onboarding_screen_controller.dart';

class OnboardingScreen2View extends GetView<OnboardingScreenController> {
  final controller = Get.put(OnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => Get.offAll(AuthScreenView()),
                      child: Visibility(
                        visible: controller.currentIndex.value != 3,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.19,
                            color: pluhgColour,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SvgPicture.asset(
                        controller.imgList[controller.currentIndex.value],
                      ),
                    ),
                  ),
                  Row(
                    children: List<Widget>.generate(
                        4,
                        (index) =>
                            _indicator(index == controller.currentIndex.value)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    width: 355.42.w,
                    height: 155.h,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.title[controller.currentIndex.value],
                          style: TextStyle(
                            color: pluhgColour,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        Text(
                          controller.subTitle[controller.currentIndex.value],
                          style: TextStyle(
                              color: pluhgMenuBlackColour,
                              fontSize: 18.sp,
                              height: 1.56),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: controller.currentIndex.value > 0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 115.w),
                          child: PluhgButton(
                            text: 'Previous',
                            borderWidth: 0,
                            borderRadius: 0,
                            borderColor: Colors.transparent,
                            textColor: pluhgColour,
                            color: Colors.transparent,
                            onPressed: () {
                              if (controller.currentIndex.value > 0) {
                                controller.currentIndex.value -= 1;
                              }
                            },
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 115.w),
                        child: PluhgButton(
                          borderRadius: 15,
                          text: controller.currentIndex.value == 3
                              ? 'Sign Up'
                              : 'Next',
                          onPressed: () {
                            if (controller.currentIndex.value == 3) {
                              Get.offAll(() => AuthScreenView());
                            } else {
                              controller.currentIndex.value += 1;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _indicator(bool isCurrent) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: isCurrent ? 25.44.w : 20.44.w,
      height: 7.79.h,
      margin: EdgeInsets.only(right: 5.46.w),
      decoration: BoxDecoration(
        color: isCurrent ? pluhgGreenColour : pluhgMilkColour,
        borderRadius: BorderRadius.circular(50.r),
      ),
    );
  }
}
