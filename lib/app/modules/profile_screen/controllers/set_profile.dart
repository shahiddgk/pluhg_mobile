import 'package:country_code_picker/country_code.dart';
import 'package:get/get.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/utils/location.dart';

class SetProfileScreenController extends GetxController {
  //TODO: Implement ProfileScreenController
  var currentCountryCode = ''.obs;
  RxBool isLoading = false.obs;
  RxString isoCountryCode = ''.obs;
  RxDouble lat = 0.0.obs, long = 0.0.obs;
  final size = Get.size;
  @override
  void onInit() {
    fetchCountryCode();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<String> fetchCountryCode() async {
    print("[SetProfileScreenController:fetchCountryCode] start fetching iso country code");
    User user = await UserState.get();
    String countryCode;
    if (user.countryCode.isNotEmpty) {
      countryCode = user.countryCode;
      print(
          "[SetProfileScreenController:fetchCountryCode] the code have been fetched from the User State [$countryCode]");
    } else {
      countryCode = await DeviceCountryCode.get();
      print(
          "[SetProfileScreenController:fetchCountryCode] the code has been fetched from the DeviceCountryCode [$countryCode]");
    }

    currentCountryCode.value = countryCode.isNotEmpty ? countryCode : User.DEFAULT_COUNTRY_CODE;
    return currentCountryCode.value;
  }

  Future<void> updateCountryCode(CountryCode? countryCode) async {
    final isoCode = countryCode!.code ?? User.DEFAULT_COUNTRY_CODE;
    final dialCode = countryCode.dialCode ?? '';
    print("[SetProfileScreenController:updateCountryCode] selected sim country code ($countryCode) [$isoCode]");

    isoCountryCode.value = isoCode;
    currentCountryCode.value = dialCode;
  }
}
