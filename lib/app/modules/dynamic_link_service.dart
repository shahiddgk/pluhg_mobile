import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../services/UserState.dart';

class DynamicLinkService {
  Future<void> _listenForDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      deepCallBack(deepLink: deepLink, activateDialog: false);
      // this._handleDeepLink(context, deepLink, true);
    }, onError: (error) async {
      print('error is $error');
      deepCallBack(deepLink: null, activateDialog: false);
    });
  }

  Future<void> retrieveDynamicLink() async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      deepCallBack(deepLink: deepLink, activateDialog: false);
      _listenForDynamicLink();
    } catch (e) {
      print(e);
      deepCallBack(deepLink: null, activateDialog: false);
    }
  }

  deepCallBack({Uri? deepLink, bool? activateDialog}) async {
    User user = await UserState.get();
    if (deepLink == null ||
        deepLink.queryParameters.containsKey("id") == false) {
      return;
    }

    String? id = deepLink?.queryParameters["id"]!;
    print('[_handleDeepLink] the dynamic link id is $id');

    user.setDynamicLink(id!);
    await UserState.store(user);
  }
}
