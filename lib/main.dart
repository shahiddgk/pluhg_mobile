import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluhg/core/config/service_locator.dart';
import 'package:pluhg/core/navigator/app_route.dart';
import 'package:pluhg/core/navigator/generate_route.dart';
import 'package:pluhg/core/values/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pluhg',
         theme: ThemeData(fontFamily: "Axiforma", primaryColor: AppColors.pluhgColour),
        builder: (context, widget) {
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        initialRoute: AppRoute.SPLASH_SCREEN,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
