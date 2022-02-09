import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/services/UserState.dart';

class ConnectionScreenController extends GetxController with SingleGetTickerProviderMixin {
  //TODO: Implement ConnectionScreenController
  dynamic userProfileDetails = {}.obs;
  List recommended = [];

  //late Future activeDataList,waitingConnectionDataList,whoIConnectedDataList;
  var data;
  RxInt currentIndex = 0.obs;
  RxInt activeList = 0.obs;
  RxInt waitingList = 0.obs;
  RxInt connectedList = 0.obs;
  Rx<User> user = User.empty().obs;

  APICALLS apicalls = APICALLS();

  @override
  void onInit() {
    super.onInit();
    //get first tab response
    //getActiveConnection();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  /* getWaitingConnection(){
    waitingConnectionDataList = waitingData();
  }

  getActiveConnection(){
    activeDataList = activeData();
  }

  getWhoIConnected(){
    whoIConnectedDataList = whoIconnectedData();
  }*/

  activeData() async {
    this.user.value = await UserState.get();

    data = await apicalls.getActiveConnections(
      token: this.user.value.token,
      contact: this.user.value.phone,
      // contact: prefs.get("phoneNumber").toString(),
    );
/*    if (data == null) {
      return Get.offAll
      (AuthScreenView());
    }*/

    if (data["data"] == null) {
      activeList.value = 0;
      return null;
    }

    activeList.value = data["data"].length;
    return data["data"];
  }

  waitingData() async {
    User user = await UserState.get();

    data = await apicalls.getWaitingConnections(
      token: user.token,
      contact: user.phone,
      // contact: prefs.get("phoneNumber").toString(),
    );

    if (data["data"] == null) {
      waitingList.value = 0;
      return null;
    }

    waitingList.value = data["data"].length;
    return data["data"];
  }

  whoIconnectedData() async {
    this.user.value = await UserState.get();

    data = await apicalls.getRecommendedConnections(
      token: this.user.value.token,
      userID: this.user.value.id,
      // contact: prefs.get("phoneNumber").toString(),
    );

    if (data["data"] == null) {
      connectedList.value = 0;
      return null;
    }

    connectedList.value = data["data"].length;
    return data["data"];
  }
}
