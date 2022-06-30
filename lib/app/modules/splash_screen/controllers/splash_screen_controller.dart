import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/UserState.dart';
import '../../../values/strings.dart';
import '../../auth_screen/views/auth_screen_view.dart';
import '../../home/views/home_view.dart';
import '../../onboarding_screen/views/onboarding_screen_view.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}

  //load splash screen for 2 second and redirect to proper page
  getInit() async {
    Future.delayed(Duration(seconds: 3), () async {
      User user = await UserState.get();
      SharedPreferences storage = await SharedPreferences.getInstance();
      bool? isFirstRun = storage.getBool(PREF_IS_FIRST_APP_RUN);
      Get.offAll(this._getScreen(user, isFirstRun));
    });
  }

// if isFirstRun user is new so will be directed to boarding screen
// else if isAuthenticated is false just then AuthScreen
// else Homepage
  dynamic _getScreen(User user, bool? isFirstRun) {
    print("[Splash::_getScreen] user [${user.toString()}]");
    if (isFirstRun == null || isFirstRun) {
      return OnboardingScreenView();
    }

    if (user.isAuthenticated == false) {
      return AuthScreenView();
    }
    // registered user
    return HomeView(index: 1);
  }
}
