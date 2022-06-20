import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future<void> retrieveDynamicLink(
      {required Function(Uri? deeplink, bool? activate) deepCallBack}) async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      print('---------------------->${deepLink.toString()}');
      deepCallBack(deepLink, false);
      //this._handleDeepLink(context, deepLink);
    } catch (e) {
      print(e);
      deepCallBack(null, false);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      // final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = dynamicLink?.link;

      print('FROM LINK---------------------->${deepLink.toString()}');
      deepCallBack(deepLink, false);
      // this._handleDeepLink(context, deepLink, true);
    }, onError: (error) async {
      print('error is $error');
      deepCallBack(null, false);
    });
  }
}
