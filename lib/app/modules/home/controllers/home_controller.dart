import 'dart:io';

import 'package:get/get.dart';
import 'package:plug/app/modules/dynamiclinkservice.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
 RxInt currentIndex=0.obs;
 
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
   Future<bool> willPopCallback() async {
    exit(0);
  }

  void retrieveDynamicLink() {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    _dynamicLinkService.retrieveDynamicLink(context: Get.context!);
  }
}
