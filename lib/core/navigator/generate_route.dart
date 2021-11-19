import 'package:flutter/material.dart';
import 'package:pluhg/_404.dart';
import 'package:pluhg/core/navigator/app_route.dart';
import 'package:pluhg/core/widgets/status_screen.dart';
import 'package:pluhg/features/auth/presentation/screens/login_screen.dart';
import 'package:pluhg/features/auth/presentation/screens/otp_screen.dart';
import 'package:pluhg/features/splash_screen/splash_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // Map? args = settings.arguments as Map;
  String? name = settings.name;

  switch (name) {
    case AppRoute.SPLASH_SCREEN:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case AppRoute.AUTH_SCREEN:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case AppRoute.OTP_SCREEN:
      return MaterialPageRoute(builder: (_) => const OTPScreen());
    default:
      return MaterialPageRoute(builder: (_) => const UnknownScreen());
  }
}
