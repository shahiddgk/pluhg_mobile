import 'package:get/get.dart';
import 'package:plug/app/modules/auth_screen/bindings/auth_screen_binding.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/modules/chat_screen/bindings/chat_screen_binding.dart';
import 'package:plug/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:plug/app/modules/connection_screen/bindings/connection_screen_binding.dart';
import 'package:plug/app/modules/connection_screen/views/connection_screen_view.dart';
import 'package:plug/app/modules/notification_screen/bindings/notification_screen_binding.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/modules/onboarding_screen/bindings/onboarding_screen_binding.dart';
import 'package:plug/app/modules/onboarding_screen/views/onboarding_screen_view.dart';
import 'package:plug/app/modules/profile_screen/bindings/profile_screen_binding.dart';
import 'package:plug/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:plug/app/modules/recommendation_screen/bindings/recommended_connection_screen_binding.dart';
import 'package:plug/app/modules/recommendation_screen/views/recommended_connection_screen.dart';
import 'package:plug/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:plug/app/modules/splash_screen/views/splash_screen_view.dart';
import 'package:plug/app/modules/support_screen/bindings/support_screen_binding.dart';

import 'package:plug/app/modules/support_screen/views/support_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTION_SCREEN,
      page: () => ConnectionScreenView(0),
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
    GetPage(
      name: _Paths.RECOMMENDATION_SCREEN,
      page: () => RecommendedScreenView(),
      binding: RecommendedConnectionScreenBinding(),
    ),
 
  ];
}
