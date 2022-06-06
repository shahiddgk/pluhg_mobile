import 'package:country_code_picker/country_code.dart';
import 'package:get/get.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/utils/location.dart';

class SetProfileScreenController extends GetxController {
  //TODO: Implement ProfileScreenController
  var currentCountryCode = ''.obs;
  RxBool isLoading = true.obs;
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
    print(
        "[SetProfileScreenController:fetchCountryCode] start fetching iso country code");
    User user = await UserState.get();
    String countryCode = '';
    if (user.regionCode.isNotEmpty) {
      countryCode = user.regionCode;
      print(
          "[SetProfileScreenController:fetchCountryCode] the code have been fetched from the User State [$countryCode]");
    } else {
      try {
        countryCode = await DeviceCountryCode.get();
        print(
            "[SetProfileScreenController:fetchCountryCode] the code has been fetched from the DeviceCountryCode [$countryCode]");
      } catch (e) {
        print(e);
      }
    }

    if (countryCode.isNotEmpty) {
      isoCountryCode.value = countryCode;
      user.regionCode = isoCountryCode.value;
      await UserState.store(user);
    } else {
      isoCountryCode.value = User.DEFAULT_REGION_CODE;
    }

    isLoading.value = false;
    return currentCountryCode.value;
  }

  Future<void> updateCountryCode(CountryCode? countryCode) async {
    final isoCode = countryCode!.code ?? User.DEFAULT_REGION_CODE;
    final dialCode = countryCode.dialCode ?? '';
    print(
        "[SetProfileScreenController:updateCountryCode] selected sim country code ($countryCode) [$isoCode]");

    isoCountryCode.value = isoCode;
    currentCountryCode.value = dialCode;
  }
}
