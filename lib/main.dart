import 'dart:io';

import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/home/controllers/home_controller.dart';
import 'package:plug/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:plug/app/modules/splash_screen/controllers/notification_controller.dart';
import 'package:plug/app/widgets/colors.dart';

import 'app/modules/chat_screen/controllers/chat_screen_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/snack_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureFirebase();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_) => GetMaterialApp(
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
        theme: ThemeData(
          fontFamily: "Axiforma",
          primaryColor: pluhgColour,
          backgroundColor: Colors.white,
        ),
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

//Too recieve FCM notification
void _configureFirebase() async {
  await Firebase.initializeApp();
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission();
  }
  await FirebaseMessaging.instance.getToken();
  final controller = Get.put(NotificationController());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    pluhgSnackBar('Notification', "Received Message".toString());
    controller.fcmNotificationReceived();

    final tempCtx = Get.find<ChatScreenController>().connect();


    Get.put(HomeController()).notificationCount.value ++;

    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification!.body.toString()}');
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final controller = Get.put(NotificationController());
  controller.fcmNotificationReceived();
  pluhgSnackBar('Notification', "Received Message".toString());
  Get.put(HomeController()).notificationCount.value ++;
  print("Handling a background message: ${message.messageId}");
}
