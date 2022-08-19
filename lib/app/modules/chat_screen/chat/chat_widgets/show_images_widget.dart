import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/chat_screen/chat/chat_widgets/fullscreen_image.dart';
import 'package:plug/app/modules/chat_screen/chat/chat_widgets/images_list.dart';
import 'package:plug/app/values/colors.dart';

class ImagesChatWidget extends StatelessWidget {
  ImagesChatWidget(this.list_images, {Key? key}) : super(key: key);
  List<String> list_images;

  @override
  Widget build(BuildContext context) {
    Widget image_item(String im, double width, double height) => InkWell(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(18.0.r),
            child: Container(
                color: Colors.grey[100],
                width: width,
                height: height,
                child: FadeInImage.assetNetwork(
                    width: width,
                    height: height,
                    placeholder: "assets/images/camera.png",
                    image: APICALLS.imageBaseUrl + im,
                    fit: BoxFit.cover))),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenWrapper(
                  imageProvider: CachedNetworkImageProvider(APICALLS.imageBaseUrl + im.toString()),
                  backgroundColor: Colors.black,
                ),
              ));
        });

    images_widget() {
      Widget wid;
      switch (list_images.length) {
        case 0:
          wid = Container();
          break;
        case 1:
          wid = Container(
              width: 140.w,
              height: 120.h,
              child: image_item(list_images[0].toString(), 140.0.w, 120.h));
          break;

        case 2:
          wid = Container(
              width: 140.w,
              height: 120.h,
              child: Row(
                children: [
                  Expanded(child: image_item(list_images[0], 70.0.w, 120.h)),
                  Container(width: 6.w),
                  Expanded(child: image_item(list_images[1], 70.0.w, 120.h))
                ],
              ));
          break;

        case 3:
          wid = Container(
              width: 144.w,
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: image_item(list_images[0], 70.0.w, 120.h)),
                      Container(
                        width: 6.w,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              image_item(list_images[1], 70.0.w, 60.h),
                              Container(height: 4.w),
                              image_item(list_images[1], 70.0.w, 60.h)
                            ],
                          ))
                    ],
                  )));

          break;
        default:
          wid = Container(
              width: 144.w,
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: image_item(list_images[0], 70.0.w, 120.h)),
                      Container(
                        width: 6.w,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              image_item(list_images[1], 70.0.w, 60.h),
                              Container(height: 4.w),
                              Container(
                                  width: 70.0.w,
                                  height: 60.h,
                                  child: InkWell(
                                      child: Stack(children: [
                                        Positioned.fill(
                                            child: image_item(
                                                list_images[1], 70.0.w, 60.h)),
                                        Align(
                                            alignment: Alignment.center,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    18.0.r),
                                                child: Container(
                                                    width: 70.w,
                                                    height: 60.h,
                                                    color: AppColors
                                                        .activeIconColour
                                                        .withOpacity(0.65),
                                                    child: Center(
                                                        child: Text(
                                                            "+ " +
                                                                (list_images.length - 3)
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 22.sp,
                                                                fontWeight:
                                                                    FontWeight.bold))))))
                                      ]),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new ImageList(
                                                            list_images)));
                                      }))
                            ],
                          ))
                    ],
                  )));
          break;
      }
      return wid;
    }

    return images_widget();
  }
}
