import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/widgets/image.dart';

Widget getMainChatList() {
  return new Container(
    height: 84.0,
    width: Get.width,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26.0),
            child: Container(
                child: networkImage(52, 52,
                    "https://file-examples-com.github.io/uploads/2017/10/file_example_JPG_100kB.jpg")),
          ),
        ),
        SizedBox(
          width: Get.width - (52 + 8 + 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text("Username",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                color: Color(0xff242037),
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                            textAlign: TextAlign.start),
                      ),
                    ),
                    Text("just now",
                        maxLines: 1,
                        style: TextStyle(
                            color: Color(0xff8D8D8D),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center)
                  ],
                ),
                new Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                            "This is This is a messages/2017/10/f This is This is a messages/2017/10/f",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                color: Color(0xff8D8D8D),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.start),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.pluhgColour, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("12",
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
