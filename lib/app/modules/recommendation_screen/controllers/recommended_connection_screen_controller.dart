import 'package:get/get.dart';
import 'package:plug/app/data/api_urls.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';

class RecommendedConnectionScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<ConnectionResponseModel> getConnectionDetails(
      String connectionID) async {
    //APICALLS apicalls = new APICALLS();
    try {
      ConnectionResponseModel data =
          await HTTPManager().getConnectionDetails(path: ApplicationURLs.API_GET_RECOMMENDED_CONNECTION_DETAILS , connectionId: connectionID);
      // await apicalls.getConnectionDetails(connectionID: connectionID);
      return data;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
