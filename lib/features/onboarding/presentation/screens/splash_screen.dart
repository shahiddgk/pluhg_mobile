import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pluhg/core/styles/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.pluhgColour,
        body: Center(
            child: SvgPicture.asset("assets/svgs/onboarding/logo_text.svg")));
  }
}
