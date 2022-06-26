import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/modules/connection_screen/controllers/connection_screen_controller.dart';
import 'package:plug/app/modules/connection_screen/views/active_connection.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

Widget activeConnectionCard({
  required Rx<User> user,
  required ConnectionResponseModel data,
}) {
  var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data.createdAt ?? "")
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
  return GestureDetector(
    onTap: () {
      Get.to(
            () =>
            ActiveConnectionScreenView(
              data: data,
              // isRequester: user.value.compareEmail(data["requester"]["refId"]["emailAddress"]) || user.value.comparePhone(data["requester"]["refId"]["phoneNumber"]),
              isRequester: user.value.compareId('${data.requester?.refId?.sId}'),
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
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0), child: IntrinsicHeight(
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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    width: 87.2.w,
                                    padding: EdgeInsets.all(6.0.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black12,
                                            blurRadius: 20)
                                      ],
                                    ),
                                    child: card(
                                      Get.context!,
                                      data.userId!,
                                      data.requester!,
                                    ),
                                  ),
                                  Container(
                                    width: 87.2.w,
                                    padding: EdgeInsets.all(6.0.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black12,
                                            blurRadius: 20)
                                      ],
                                    ),
                                    child: card(
                                      Get.context!,
                                      data.userId!,
                                      data.contact!,
                                    ),
                                  ),
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
                      userName: (data.userId?.userName ?? "").isEmpty
                          ? data.userId?.name ?? ""
                          : "@" + (data.userId?.userName ?? ""),
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
                ))),
            if(data.closeConnection ?? false)
            Container(
              margin: EdgeInsets.only(
                top: 12.0.h,
                left: 24.0.w,
                right: 24.0.w,
                bottom: 12.h,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFA4A4A4),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  "Closed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ]),
    ),);
}
