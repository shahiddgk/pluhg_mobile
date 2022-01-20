import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/connection_screen/controllers/connection_screen_controller.dart';
import 'package:plug/app/modules/connection_screen/views/active_connection.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/widgets/image.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget activeConnectionCard({
  required dynamic data,
  required dynamic prefs,
}) {
  var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data["created_at"])
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
  return GestureDetector(
    onTap: () {
      Get.to(() => ActiveConnectionScreenView(
            data: data,
            isRequester: prefs.getString(prefuseremail).toString() ==
                        data["requester"]["refId"]["emailAddress"] ||
                    prefs.getString(prefuserphone).toString() ==
                        data["requester"]["refId"]["phoneNumber"]
                ? true
                : false,
            refreshActiveConnection: () {
              final controller = Get.put(ConnectionScreenController());
              controller.activeData();
            },
          ));
    },
    child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.size.width * 0.04),
        width: Get.width,
        height: 164,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xffEBEBEB),
            boxShadow: [BoxShadow(blurRadius: 40, color: Colors.black12)]),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 164,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 40, color: Color.fromARGB(5, 0, 0, 0))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 151.72.h,
                        width: 84.w,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20)
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16)),
                              child: data == null ||
                                      !data["requester"]["refId"]
                                          .containsKey("profileImage") ||
                                      data["requester"]["refId"]
                                              ["profileImage"] ==
                                          null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: SvgPicture.asset(
                                            "resources/svg/profile.svg"),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.network(
                                        APICALLS.imageBaseUrl +
                                            "${data["requester"]["refId"]['profileImage'].toString()}",
                                        height: 64.h,
                                        width: 64.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 4.0.h,
                            ),
                            data != null &&
                                    data["requester"]["refId"]
                                        .containsKey("userName") &&
                                    data["requester"]["refId"]["userName"] !=
                                        null
                                ? Text(
                                    "@${data["requester"]["refId"]["userName"]}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xff8D8D8D),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center)
                                : Text(
                                    data == null
                                        ? "Empty"
                                        : "@${data["requester"]['refId']["name"]}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xff8D8D8D),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                          ],
                        )),
                    Container(
                        width: 84.w,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20)
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: data == null ||
                                      !data["contact"]["refId"]
                                          .containsKey("profileImage") ||
                                      data["contact"]["refId"]
                                              ["profileImage"] ==
                                          null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: pluhgColour,
                                        ),
                                        child: SvgPicture.asset(
                                            "resources/svg/profile.svg"),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.network(
                                        APICALLS.imageBaseUrl +
                                            "${data["contact"]["refId"]['profileImage'].toString()}",
                                        height: 64.h,
                                        width: 64.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            data != null &&
                                    data["contact"].containsKey("userName") &&
                                    data["contact"]["userName"] != null
                                ? Text("@${data["contact"]["userName"]}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xff8D8D8D),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center)
                                : Text(
                                    data == null
                                        ? "Contact"
                                        : "@${data["contact"]["name"]}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color(0xff8D8D8D),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              width: 12.w,
            ),
            PlugByWidgetCard(
                userName: data['userId']["userName"] == null
                    ? data['userId']["name"]
                    : "@" + data['userId']["userName"],
                date: formattedDate),
            Container(
              width: 8.w,
            ),
            Center(
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Color(0xff575858),
              ),
            ),
            SizedBox(
              width: 12,
            )
          ],
        )),
  );
}
