import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:plug/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:plug/app/widgets/colors.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale("en"),

          /// THIS IS FOR COUNTRY CODE PICKER
        ],
        localizationsDelegates: [
          CountryLocalizations.delegate,

          /// THIS IS FOR COUNTRY CODE PICKER
        ],
        title: 'Pluhg',
        theme: ThemeData(fontFamily: "Axiforma", primaryColor: pluhgColour),
        builder: (context, widget) {
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        initialRoute: AppPages.INITIAL,
        initialBinding: SplashScreenBinding(),
        getPages: AppPages.routes,
      ),
    ),
  );
}

