import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'dynamic_link_service.dart';

class AppLifeCycleController extends SuperController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("applevel in On Init");
    retrieveDynamicLink();
  }

  Future<void> retrieveDynamicLink() async {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    _dynamicLinkService.retrieveDynamicLink();
  }

  @override
  void onDetached() {
    print("app in OnDetached");
  }

  @override
  void onInactive() {
    print("app in Inactive");
  }

  @override
  void onPaused() {
    print("app in OnPause");
  }

  @override
  void onResumed() {
    print("app in Resumed");
    //listenForDynamicLink();
  }
}
