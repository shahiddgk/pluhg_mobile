import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';

import 'colours.dart';

Widget card(BuildContext context, var data) {
  if (data == null) return SizedBox();
  return Column(
    children: [
      Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: !data.containsKey("profileImage") || data["profileImage"] == null
            ? Container(
                child: Center(
                  child: SvgPicture.asset("resources/svg/profile.svg"),
                ),
                decoration: BoxDecoration(color: pluhgColour, borderRadius: BorderRadius.circular(12.r)),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  APICALLS.imageBaseUrl + data['profileImage'].toString(),
                  height: 64.w,
                  width: 64.w,
                  fit: BoxFit.cover,
                )),
      ),
      Container(height: 2.h),
      data.containsKey("userName") && data["userName"] != null
          ? Text("@${data["userName"]}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xff8D8D8D), fontSize: 11.sp, height: 0.9, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center)
          : Text("@${data["name"]}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xff8D8D8D), fontSize: 11.sp, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
    ],
  );
}

Widget cardProfile2(BuildContext context, var data, String text) {
  // Size size = MediaQuery.of(context).size;
  return Column(
    children: [
      SizedBox(
        height: 10.h,
      ),
      !data.containsKey("profileImage") || data["profileImage"] == null
          ? Container(
              width: 68.73.w,
              height: 65.65.h,
              child: Center(
                child: SvgPicture.asset("resources/svg/profile.svg"),
              ),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            )
          : Container(
              width: 68.73.w,
              height: 65.65.h,
              // padding: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Get.size.width * 0.042),
                  child: Image.network(
                    APICALLS.imageBaseUrl + data['profileImage'].toString(),
                    width: 68.73.w,
                    height: 65.65.w,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
      Container(
        height: 6.h,
      ),
      data.containsKey("userName") && data["userName"] != null
          ? Expanded(
              child: Text("@${data["userName"]}",
                  style: TextStyle(color: Color(0xff8D8D8D), fontSize: 13.5.sp, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
            )
          : Expanded(
              child: Text("@${data["name"]}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xff8D8D8D), fontSize: 12.5.sp, fontWeight: FontWeight.w400),
                  maxLines: 2,
                  textAlign: TextAlign.center),
            ),
      Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      ),
      SizedBox(
        height: 8.h,
      ),
    ],
  );
}

Widget smallCard(var data, var accepted) {
  return Container(
    height: 41.03,
    width: 150,
    decoration: BoxDecoration(
        color: accepted ? Color.fromARGB(17, 9, 206, 53) : Color.fromARGB(24, 191, 161, 36),
        borderRadius: BorderRadius.circular(14)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        !data.containsKey("profileImage") || data["profileImage"] == null
            ? Container(
                child: Center(
                  child: SvgPicture.asset("resources/svg/profile.svg"),
                ),
                height: 28.82,
                width: 30.17,
                decoration: BoxDecoration(color: pluhgColour, borderRadius: BorderRadius.circular(16)),
              )
            : Container(
                height: 28.82,
                width: 30.17,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: Center(
                    child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    APICALLS.imageBaseUrl + data['profileImage'].toString(),
                  ),
                ))),
        SizedBox(
          width: Get.width * 0.013.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.containsKey("userName") && data["userName"] != null
                    ? "@" + data["userName"].toString()
                    : "@" + data["name"].toString(),
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 12),
              ),
              Row(
                children: [
                  accepted
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: Color(0xff09CE35), borderRadius: BorderRadius.circular(2)),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 8,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SvgPicture.asset("resources/svg/waiting.svg"),
                  SizedBox(
                    width: 5,
                  ),
                  Text(accepted ? "Accepted connect" : "Waiting to accept",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 10))
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
