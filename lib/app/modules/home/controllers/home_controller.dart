import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/dynamic_link_service.dart';
import 'package:plug/app/values/colors.dart';


class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxInt currentIndex = 0.obs;
  DateTime? currentBackPressTime;

  List<String> iconMenu = [
    "resources/svg/connection_menu.svg",
    "resources/svg/connect2p_menu.svg",
    "resources/svg/message_menu.svg",
    "resources/svg/settings_menu.svg",
  ];
  List<String> iconText = [
    "Connections",
    "Connect",
    "Messages",
    "Settings",
  ];
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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
          fontSize: 16.0
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  void retrieveDynamicLink() {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    _dynamicLinkService.retrieveDynamicLink(context: Get.context!);
  }
}
