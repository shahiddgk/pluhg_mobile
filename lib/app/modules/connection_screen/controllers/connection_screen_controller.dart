import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/services/UserState.dart';

class ConnectionScreenController extends GetxController
    with SingleGetTickerProviderMixin {
  //TODO: Implement ConnectionScreenController
 // dynamic userProfileDetails = {}.obs;

  //List recommended = [];

  //late Future activeDataList,waitingConnectionDataList,whoIConnectedDataList;
//  var data;
  RxInt currentIndex = 0.obs;
//   RxInt activeList = 0.obs;
//   RxInt waitingList = 0.obs;
//   RxInt connectedList = 0.obs;

 Rx<User> user = User.empty().obs;
  RxList whoIConnectedList = [].obs;
  RxList activeConnectionList = [].obs;
  RxList waitingConnectionList = [].obs;

  //APICALLS apicalls = APICALLS();

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
    ConnectionListModel connectionListModel = await HTTPManager().getActiveConnections();
    activeConnectionList.value = connectionListModel.values;
    return activeConnectionList;
    // HTTPManager().getActiveConnections().then((value) {
    //   activeConnectionList.value = value.values;
    //   return activeConnectionList.value;
    // }).catchError((onError) {});
//     this.user.value = await UserState.get();
//
//     data = await apicalls.getActiveConnections(
//       token: this.user.value.token,
//       contact: this.user.value.phone,
//       // contact: prefs.get("phoneNumber").toString(),
//     );
// /*    if (data == null) {
//       return Get.offAll
//       (AuthScreenView());
//     }*/
//
//     if (data["data"] == null) {
//       activeList.value = 0;
//       return null;
//     }
//
//     activeList.value = data["data"].length;
//     return data["data"];
  }

  waitingData()  async {
    this.user.value = await UserState.get();
    ConnectionListModel connectionListModel = await HTTPManager().getWaitingConnections();
    waitingConnectionList.value = connectionListModel.values;
    return waitingConnectionList;
    // HTTPManager().getWaitingConnections().then((value) {
    //   waitingConnectionList.value = value.values;
    //   return waitingConnectionList.value;
    // }).catchError((onError) {});
    // User user = await UserState.get();
    //
    // data = await apicalls.getWaitingConnections(
    //   token: user.token,
    //   contact: user.phone,
    //   // contact: prefs.get("phoneNumber").toString(),
    // );
    //
    // if (data["data"] == null) {
    //   waitingList.value = 0;
    //   return null;
    // }
    //
    // List<dynamic> temp = data['data'];
    // temp.removeWhere((element) => element['userId']['_id'] == user.id);
    // //return data["data"];
    // waitingList.value = temp.length;
    // return temp;
  }

  whoIconnectedData() async {
    this.user.value = await UserState.get();
    ConnectionListModel connectionListModel = await HTTPManager().getRecommendedConnections();
    whoIConnectedList.value = connectionListModel.values;
    return whoIConnectedList;
    // HTTPManager().getRecommendedConnections().then((value) {
    //   whoIConnectedList.value = value.values;
    //   return whoIConnectedList.value;
    // }).catchError((onError) {});
    // data = await apicalls.getRecommendedConnections(
    //   token: this.user.value.token,
    //   userID: this.user.value.id,
    //   // contact: prefs.get("phoneNumber").toString(),
    // );
    //
    // if (data["data"] == null) {
    //   connectedList.value = 0;
    //   return null;
    // }
    //
    // connectedList.value = data["data"].length;
    // return data["data"];
  }
}
