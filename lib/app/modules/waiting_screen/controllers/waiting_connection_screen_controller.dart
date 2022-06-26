import 'package:get/get.dart';
import 'package:plug/app/data/api_urls.dart';
import 'package:plug/app/services/UserState.dart';

import '../../../data/http_manager.dart';
import '../../../data/models/response/connection_response_model.dart';

class WaitingConnectionScreenController extends GetxController {
  RxBool isRequester = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future<ConnectionResponseModel> getWaitingConnection(
      String connectionID) async {
    try {
      ConnectionResponseModel data = await HTTPManager().getConnectionDetails(
          path: ApplicationURLs.API_GET_WAITING_CONNECTION_DETAILS,
          connectionId: connectionID);
        User user = await UserState.get();
        if('${data.requester?.refId?.sId}' == user.id){
          isRequester.value =  true;
        }
      return data;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
