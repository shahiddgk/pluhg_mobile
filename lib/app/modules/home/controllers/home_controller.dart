import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/app/widgets/snack_bar.dart';

import '../../../services/UserState.dart';
import '../../waiting_screen/views/waiting_connection_screen.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxInt currentIndex = 0.obs;
  DateTime? currentBackPressTime;

  APICALLS apicalls = APICALLS();

  Rx<int> notificationCount = 0.obs;

  List<String> iconMenu = [
    "resources/svg/connection_menu.svg",
    "resources/svg/connect2p_menu.svg",
    "resources/svg/message_menu.svg",
    "resources/svg/settings_menu.svg",
  ];
  List<String> iconText = [
    "Connections",
    "Connect People",
    "Messages",
    "Settings",
  ];
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getNotificationCount();
  }

  @override
  void onReady() {
    super.onReady();
  }

  goToDeepLink() async {
    User user = await UserState.get();
    if (user.dynamicLink.isNotEmpty) {
      String id = user.dynamicLink;
      Get.to(() => WaitingScreenView(connectionID: id));
      user.setDynamicLink("");
      await UserState.store(user);
    }
  }

  getNotificationCount() async {
    HTTPManager()
        .getNotificationCount()
        .then((value) => {notificationCount.value = value})
        .catchError((onError) {
      pluhgSnackBar('Sorry', onError.toString());
    }); //
// var result =  apicalls.getNotificationCount();
//     if(result != null){
//       notificationCount.value = result;
//     }
  }

  @override
  void onClose() {}

  void increment() => count.value++;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 3)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Double press to exit",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.pluhgColour,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
