import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/widgets/image.dart';

import '../app/data/models/response/connection_response_model.dart';

Widget card(BuildContext context, RefId connector, Requester data,
    {bool whoIConnected = false}) {
  if (data == null) return SizedBox();

  final userName = extractUserName(connector, data, whoIConnected);
  return Column(
    children: [
      Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: cachedNetworkImageWidget(
          imageUrl: APICALLS.imageBaseUrl + (data?.refId?.profileImage ?? ""),
          height: 64.w,
          width: 64.w,
          borderRadiusValue: 12.r,
        ),
      ),
      Container(height: 2.h),
      Text(
        "$userName",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Color(0xff8D8D8D),
            fontSize: 11.sp,
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

//@todo should be a part of DTO/Model
String? extractUserName(RefId connector, Requester data, bool whoIConnected) {
  final userName = data.refId?.userName;
  final name = data.refId?.name; //data["name"];

  final isUserNameExists = userName != null && userName.isNotEmpty;
  final isContactNameExists = name != null && name.isNotEmpty;
  if (isUserNameExists) {
    return "@$userName";
  }
  if (isContactNameExists) {
    return name;
  }
  if (whoIConnected) {
    return data?.name;
  }
  return "${connector.userName}'s Contact";
}

Widget cardProfile2(BuildContext context, RefId connector, Requester data,
    String text,
    {bool whoIConnected = false}) {
  if (data == null) return SizedBox();

  final userName = extractUserName(connector, data, whoIConnected);
  return Column(
    children: [
      SizedBox(
        height: 10.h,
      ),
      Center(
        child: cachedNetworkImageWidget(
          imageUrl: APICALLS.imageBaseUrl + (data.refId?.profileImage ?? ""),
          width: 68.73.w,
          height: 65.65.w,
          borderRadiusValue: Get.size.width * 0.042,
        ),
      ),
      Container(
        height: 6.h,
      ),
      Expanded(
        child: Text("$userName",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color(0xff8D8D8D),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400),
            maxLines: 2,
            textAlign: TextAlign.center),
      ),
      Text(
        text,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      ),
      SizedBox(
        height: 8.h,
      ),
    ],
  );
}

Widget smallCard(RefId connector, Requester data, var accepted,
    {bool whoIConnected = false}) {
  if (data == null) return SizedBox();

  final userName = extractUserName(connector, data, whoIConnected);
  return Container(
    height: 41.03,
    width: 150,
    decoration: BoxDecoration(
        color: accepted
            ? Color.fromARGB(17, 9, 206, 53)
            : Color.fromARGB(24, 191, 161, 36),
        borderRadius: BorderRadius.circular(14)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            height: 28.82,
            width: 30.17,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Center(
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    APICALLS.imageBaseUrl + (data.refId?.profileImage ?? ""),
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
                "$userName",
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 12),
              ),
              Row(
                children: [
                  accepted
                      ? Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Color(0xff09CE35),
                        borderRadius: BorderRadius.circular(2)),
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
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 10))
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
