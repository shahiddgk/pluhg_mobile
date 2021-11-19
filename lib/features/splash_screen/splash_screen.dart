import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pluhg/core/config/service_locator.dart';
import 'package:pluhg/core/data_source/local_source.dart';
import 'package:pluhg/core/values/assets.dart';
import 'package:pluhg/core/values/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void set()async{
    await locator.get<LocalSource>().setExample("Storage Ex.");
    await locator.get<LocalSource>().setSecureExample("Secured storage Ex.");

    debugPrint(locator.get<LocalSource>().getExample());
    debugPrint(await locator.get<LocalSource>().getSecureExample());
  }
  @override
  void initState() {
    set();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.pluhgColour,
        body: Center(
            child: SvgPicture.asset(LOGO_TEXT)));
  }
}
