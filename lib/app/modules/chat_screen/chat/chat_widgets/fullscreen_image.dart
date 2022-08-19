

import 'package:photo_view/photo_view.dart';

import 'package:flutter/material.dart';

class FullScreenWrapper extends StatelessWidget {
  final ImageProvider imageProvider;
  final Color backgroundColor;
  final dynamic minScale;
  final dynamic maxScale;

  FullScreenWrapper(
      {required this.imageProvider,
        required this.backgroundColor,
        this.minScale,
        this.maxScale});

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.close,
                  color: Colors.grey[50],
                  size: 26.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
        backgroundColor: Colors.black87,
        body: new Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: new PhotoView(
              imageProvider: imageProvider,
              initialScale: PhotoViewComputedScale.contained,
              // backgroundColor: backgroundColor,
              minScale: PhotoViewComputedScale.contained * (0.5 + 1 / 10),
              maxScale: PhotoViewComputedScale.covered * 1.1,
            )));
  }
}
