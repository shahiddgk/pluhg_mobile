import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionScreenController extends GetxController
    with SingleGetTickerProviderMixin {
  //TODO: Implement ConnectionScreenController
  dynamic userProfileDetails = {}.obs;
  List recommended = [];

  SharedPreferences? prefs;
  RxInt currentIndex = 0.obs;
  RxInt activeList = 0.obs;
  RxInt waitingList = 0.obs;
  RxInt connectedList = 0.obs;
  APICALLS apicalls = APICALLS();

  @override
  void onInit() {
    super.onInit();
    preference();

    // fetchProfileDetails();
  }

  void preference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  activeData() async {
    prefs = await SharedPreferences.getInstance();

    var data = await apicalls.getActiveConnections(
      token: prefs!.getString("token").toString(),
      // contact: prefs.get("phoneNumber").toString(),
      contact: prefs!.getString("emailAddress").toString(),
    );
/*    if (data == null) {
      return Get.offAll
      (AuthScreenView());
    }*/
    if (data["data"] != null) {
      activeList.value = data["data"].length;
      return data["data"];
    } else {
      activeList.value = 0;
      return null;
    }
  }

  waitingData() async {
    prefs = await SharedPreferences.getInstance();
    var data = await apicalls.getWaitingConnections(
      token: prefs!.getString("token").toString(),
      // contact: prefs.get("phoneNumber").toString(),
      contact: prefs!.getString("emailAddress").toString(),
    );
    if (data["data"] != null) {
      waitingList.value = data["data"].length;
      return data["data"];
    } else {
      waitingList.value = 0;
      return null;
    }
  }

  whoIconnectedData() async {
    prefs = await SharedPreferences.getInstance();

    var data = await apicalls.getRecommendedConnections(
      token: prefs!.getString("token").toString(),
      // contact: prefs.get("phoneNumber").toString(),
      userID: prefs!.getString("userID").toString(),
    );
    if (data["data"] != null) {
      connectedList.value = data["data"].length;
      return data["data"];
    } else {
      connectedList.value = 0;
      return null;
    }
  }
}
