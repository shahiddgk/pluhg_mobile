import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class OTPScreenController extends GetxController {
  //TODO: Implement AuthScreenController

  var str = "Didn't Receive OTP?\n ".obs;
  var otp=''.obs;
  var fcmToken = "";

  RxBool loading = false.obs;
  Timer? _timer;
  RxInt start = 40.obs;
  final size = Get.size;


  // Wait 1 second to add resend option
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


  // Get token device
  fetchFCMToken(){
    try{
      FirebaseMessaging.instance.getToken().then((value){
        print("FCM TOKEN $value");
        fcmToken = value ?? "";
      });
    }catch(e){
      print(e.toString());
    }

  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    fetchFCMToken();
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
