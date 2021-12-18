import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';

class RecommendedConnectionScreenController extends GetxController{
  @override
  void onInit() {
    _getWaitingConnection();
    super.onInit();
  }

  void _getWaitingConnection() {
    APICALLS apicalls = new APICALLS();

  }

}