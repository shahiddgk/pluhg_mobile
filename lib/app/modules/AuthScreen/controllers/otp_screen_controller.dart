import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:plug/app/widgets/dialog_box.dart';

class OTPScreenController extends GetxController {
  //TODO: Implement AuthScreenController

  var str = "Didn't Receive OTP?\n ".obs;
  var otp=''.obs;

  RxBool loading = false.obs;
  Timer? _timer;
  RxInt start = 40.obs;
  final size = Get.size;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          otp.value = "RESEND";
        } else {
          start.value--;
        }
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _timer!.cancel();
  }
}
