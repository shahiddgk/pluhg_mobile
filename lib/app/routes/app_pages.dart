import 'package:get/get.dart';

import 'package:plug/app/modules/AuthScreen/bindings/auth_screen_binding.dart';
import 'package:plug/app/modules/AuthScreen/views/auth_screen_view.dart';
import 'package:plug/app/modules/ChatScreen/bindings/chat_screen_binding.dart';
import 'package:plug/app/modules/ChatScreen/views/chat_screen_view.dart';
import 'package:plug/app/modules/OnboardingScreen/bindings/onboarding_screen_binding.dart';
import 'package:plug/app/modules/OnboardingScreen/views/onboarding_screen_view.dart';
import 'package:plug/app/modules/connectionScreen/bindings/connection_screen_binding.dart';
import 'package:plug/app/modules/connectionScreen/views/connection_screen_view.dart';
import 'package:plug/app/modules/notificationScreen/bindings/notification_screen_binding.dart';
import 'package:plug/app/modules/notificationScreen/views/notification_screen_view.dart';
import 'package:plug/app/modules/profileScreen/bindings/profile_screen_binding.dart';
import 'package:plug/app/modules/profileScreen/views/profile_screen_view.dart';
import 'package:plug/app/modules/profileScreen/views/setProfileScreen.dart';
import 'package:plug/app/modules/splashScreen/views/splash_screen_view.dart';
import 'package:plug/app/modules/supportScreen/bindings/support_screen_binding.dart';
import 'package:plug/app/modules/supportScreen/views/support_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      // binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTION_SCREEN,
      page: () => ConnectionScreenView(),
      binding: ConnectionScreenBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_SCREEN,
      page: () => AuthScreenView(),
      binding: AuthScreenBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => ChatScreenView(),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREEN,
      page: () => OnboardingScreenView(),
      binding: OnboardingScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => ProfileScreenView(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.SUPPORT_SCREEN,
      page: () => SupportScreenView(),
      binding: SupportScreenBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SCREEN,
      page: () => NotificationScreenView(),
      binding: NotificationScreenBinding(),
    ),
 
  ];
}
