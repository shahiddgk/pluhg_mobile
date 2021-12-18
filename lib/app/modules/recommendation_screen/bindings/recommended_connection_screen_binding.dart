import 'package:get/get.dart';
import 'package:plug/app/modules/recommendation_screen/controllers/recommended_connection_screen_controller.dart';

class RecommendedConnectionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecommendedConnectionScreenController>(
        () => RecommendedConnectionScreenController());
  }
}
