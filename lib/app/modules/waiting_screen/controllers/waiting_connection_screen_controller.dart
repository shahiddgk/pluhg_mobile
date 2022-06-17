import 'package:get/get.dart';
import 'package:plug/app/data/api_urls.dart';

import '../../../data/http_manager.dart';
import '../../../data/models/response/connection_response_model.dart';

class WaitingConnectionScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<ConnectionResponseModel> getWaitingConnection(
      String connectionID) async {
    //APICALLS apicalls = new APICALLS();
    try {
      ConnectionResponseModel data = await HTTPManager().getConnectionDetails(
          path: ApplicationURLs.API_GET_WAITING_CONNECTION_DETAILS,
          connectionId: connectionID);
      // await apicalls.getConnectionDetails(connectionID: connectionID);
      return data;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
