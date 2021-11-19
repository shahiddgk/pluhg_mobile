import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pluhg/core/navigator/app_route.dart';
import 'package:pluhg/core/values/assets.dart';
import 'package:pluhg/core/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluhg/core/widgets/pluhg_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          width: 375.w,
          height: 812.h,
          child: SvgPicture.asset(
            AppAsset.WELCOME_BACKGROUND,
            width: 375.w,
            height: 812.h,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            children: [
              SizedBox(height: 180.53.h),
              SvgPicture.asset(AppAsset.LOGO_TEXT),
              SizedBox(height: 108.37.h),
              Text(
                'Easily Connect People!\n( You are the Plugh! )',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  height: 1.67,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 120.01.h,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 261.w),
                child: PluhgButton(
                  text: 'Get Started',
                  color: Colors.white,
                  textColor: AppColors.pluhgColour,
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoute.ONBOARDING_SCREEN);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
