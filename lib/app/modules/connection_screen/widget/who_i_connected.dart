import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/modules/recommendation_screen/views/recommended_connection_screen.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

Widget whoIConnectedCard({
  required dynamic data,
  required Rx<User> user,
}) {
  final dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data["created_at"])
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);

  return GestureDetector(
    onTap: () {
      Get.to(
        () => RecommendedScreenView(
          connectionID: data['_id'],
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      //height: 164.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xffEBEBEB),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // height: 164,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(blurRadius: 40, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 87.2.w,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: card(
                              Get.context!,
                              data["requester"]["refId"],
                            ),
                          ),
                          Container(
                            width: 87.2.w,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: card(
                              Get.context!,
                              data["contact"]["refId"],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 28.h,
                    margin: EdgeInsets.only(
                        top: 12.0.h, left: 24.0.w, right: 24.0.w, bottom: 12.h),
                    decoration: BoxDecoration(
                      color: data["isRequesterAccepted"] &&
                              data["isContactAccepted"]
                          ? Color(0xff18C424)
                          : Color(0xffBFA124),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Text(
                        data["isRequesterAccepted"] && data["isContactAccepted"]
                            ? "Accepted"
                            : "Pending",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          PlugByWidgetCard(
            userName: data['userId']["userName"] == null
                ? data['userId']["name"]
                : "@" + data['userId']["userName"],
            date: formattedDate,
          ),
          SizedBox(
            width: 8.w,
          ),
          Center(
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Color(0xff575858),
            ),
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
    ),
  );
}
