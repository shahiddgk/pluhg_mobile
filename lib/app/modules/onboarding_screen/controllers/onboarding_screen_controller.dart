import 'package:get/get.dart';

class OnboardingScreenController extends GetxController {
  //TODO: Implement OnboardingScreenController

  final screenHeight = Get.size.height.roundToDouble();
  List<String> middleText() {
    return [];
  }

  List<String> title = [
    "You Can Connect Two People You Know",
    "Without Sharing Their Contact Details.",
    "They Decide If They Accept Or Decline Your Recommendation",
    "They Connect And Communicate In Pluhg."
  ];
  List<String> subTitle = [
    "(But don't know each other)",
    "(Connecting by a text reveals their numbers)",
    "",
    "(You are not in the middle)"
  ];
  List<String> imgList = [
    "assets/svg/onboarding1.svg",
    "assets/svg/onboarding2.svg",
    "assets/svg/onboarding3.svg",
    "assets/svg/onboarding4.svg",
  ];
  RxInt currentIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
