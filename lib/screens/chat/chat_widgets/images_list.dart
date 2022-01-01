import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/screens/chat/chat_widgets/fullscreen_image.dart';

class ImageList extends StatelessWidget {
  ImageList(this.list);

  List list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: ListView(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          children: list
              .map<Widget>((img) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenWrapper(
                            imageProvider: NetworkImage(
                                "https://pluhg.s3.us-east-2.amazonaws.com/" +
                                    img.toString()),
                            backgroundColor: Colors.black,
                          ),
                        ));
                  },
                  child: Column(
                    children: <Widget>[
                      FadeInImage.assetNetwork(
                          width: MediaQuery.of(context).size.width,
                          height: 330.h,
                          placeholder: "assets/images/camera.png",
                          image:
                              "https://pluhg.s3.us-east-2.amazonaws.com/" + img,
                          fit: BoxFit.cover),
                      Container(
                        height: 6,
                      ),
                    ],
                  )))
              .toList()),
    );
  }
}
