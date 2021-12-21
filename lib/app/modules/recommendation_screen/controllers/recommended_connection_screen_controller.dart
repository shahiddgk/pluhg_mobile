import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/models/recommendation_response.dart';

class RecommendedConnectionScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<RecommendationResponse> getWaitingConnection(
      String connectionID) async {
    APICALLS apicalls = new APICALLS();
    try{
      RecommendationResponse data =
      await apicalls.getConnectionDetails(connectionID: connectionID);
      return data;
    }catch(e){
      print(e);
      throw e;
    }

  }
}
