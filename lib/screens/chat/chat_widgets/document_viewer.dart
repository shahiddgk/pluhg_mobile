import 'package:flutter/material.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewer extends StatefulWidget {
  DocumentViewer(this.url, {Key? key}) : super(key: key);
  String url;

  @override
  _DocumentViewerState createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(backButton: true, notificationButton: false),
        body: Stack(
          children: [
            Container(
              child: WebView(
                initialUrl: widget.url,
                onPageFinished: (finished) {
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
            isLoading ? Center(child: pluhgProgress()) : Container()
          ],
        ));
  }
}
