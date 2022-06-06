import 'package:get/get.dart';

import '../controllers/waiting_connection_screen_controller.dart';

class WaitingConnectionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitingConnectionScreenController>(
        () => WaitingConnectionScreenController());
  }
}
