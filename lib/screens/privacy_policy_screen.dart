import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/constants/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(backButton: true),
        body: Stack(
          children: [
            Container(
              child: WebView(
                initialUrl: AppConstants.privacyPolicyUrl,
                onPageFinished: (finished) {
                  print("FINISH PAGE");
                  setState(() {
                    isLoading = false;
                  });
                },
                onPageStarted: (started) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onWebResourceError: (error) {
                  print(error);
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ),
            isLoading ? Center(child: pluhgProgress()) : Stack()
          ],
        ));
  }
}
