import 'package:get/get.dart';
import 'package:plug/app/modules/connectionScreen/controllers/connect_two.dart';

import '../controllers/connection_screen_controller.dart';

class ConnectionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectionScreenController>(
      () => ConnectionScreenController(),
    ); Get.lazyPut<ConnecTwoScreenController>(
      () => ConnecTwoScreenController(),
    );
  }
}
