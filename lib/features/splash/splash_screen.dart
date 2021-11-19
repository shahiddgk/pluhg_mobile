import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pluhg/core/navigator/app_route.dart';
import 'package:pluhg/core/values/assets.dart';
import 'package:pluhg/core/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pluhgColour,
      body: Stack(
        children: [
          SizedBox(
            width: 375.w,
            height: 812.h,
            child: SvgPicture.asset(
              AppAsset.SPLASH_BACKGROUND,
              width: 375.w,
              height: 812.h,
              fit: BoxFit.cover,
            ),
          ),
          BlocProvider(
            create: (context) => SplashBloc()..add(StartTimerEvent()),
            child: BlocListener<SplashBloc, SplashState>(
              listener: (context, state) {
                if (state is SplashCompleted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.WELCOME_SCREEN, (route) => false);
                }
              },
              child: Center(child: SvgPicture.asset(AppAsset.LOGO_TEXT)),
            ),
          ),
        ],
      ),
    );
  }
}
