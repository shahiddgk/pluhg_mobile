import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/modules/connection_screen/controllers/connection_screen_controller.dart';
import 'package:plug/app/modules/connection_screen/views/active_connection.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

Widget activeConnectionCard({
  required Rx<User> user,
  required dynamic data,
}) {
  var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data["created_at"])
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
  return GestureDetector(
    onTap: () {
      Get.to(
        () => ActiveConnectionScreenView(
          data: data,
         // isRequester: user.value.compareEmail(data["requester"]["refId"]["emailAddress"]) || user.value.comparePhone(data["requester"]["refId"]["phoneNumber"]),
          isRequester: data["requester"]["refId"]["emailAddress"] != null
              ? user.value.compareEmail(data["requester"]["refId"]["emailAddress"])
              : user.value.comparePhone(data["requester"]["refId"]["phoneNumber"]),
          refreshActiveConnection: () {
            Get.put(ConnectionScreenController()).activeData();
          },
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(
        vertical: Get.size.width * 0.04,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xffEBEBEB),
        boxShadow: [
          BoxShadow(blurRadius: 40, color: Colors.black12),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 40,
                      color: Color.fromARGB(5, 0, 0, 0),
                    )
                  ],
                ),
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 87.2.w,
                            padding: EdgeInsets.all(6.0.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 20)
                              ],
                            ),
                            child: card(
                              Get.context!,
                              data["requester"]["refId"],
                            ),
                          ),
                          Container(
                            width: 87.2.w,
                            padding: EdgeInsets.all(6.0.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 20)
                              ],
                            ),
                            child: card(
                              Get.context!,
                              data["contact"]["refId"],
                            ),
                          ),
                          /*  Container(
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
                                )),*/
                        ],
                      ),
                    ),
                  ),
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
              date: formattedDate,
            ),
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
        ),
      ),
    ),
  );
}
