import 'package:get/get.dart';
import 'package:plug/app/modules/auth_screen/controllers/otp_screen_controller.dart';

import '../controllers/auth_screen_controller.dart';

class AuthScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthScreenController>(
      () => AuthScreenController(),
    );
    Get.lazyPut<OTPScreenController>(
      () => OTPScreenController(),
    );
  }
}
