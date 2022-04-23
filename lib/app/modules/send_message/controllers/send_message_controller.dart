import 'package:get/get.dart';

class SendMessageController extends GetxController {
  //TODO: Implement SendMessageController
  RxString requesterMessage = "".obs;
  RxString contactMessage = "".obs;
  RxString defaultText = "".obs;
  RxString text = "Both".obs;
  RxBool loading = false.obs;
  final count = 0.obs;
  RxInt selectedRadio = 1.obs;
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
  void increment() => count.value++;

  void selectedRadioButton(int value){
    selectedRadio.value = value;
    switch(value){
      case 1 :
        text.value = "Both";
        break;
      case 2 :
        text.value = "Contact";
        break;
      case 3 :
        text.value = "Requester";
        break;
    }
  }
}
