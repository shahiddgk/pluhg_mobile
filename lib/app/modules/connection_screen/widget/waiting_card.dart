import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/request/connection_request_model.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

import '../../waiting_screen/views/waiting_connection_screen.dart';

Widget waitingConnectionCard(
    {required ConnectionResponseModel data, required Rx<User> user}) {
  bool _isRequester = user.value.compareId(data.requester?.refId?.sId! ?? "");

  var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : (data.createdAt ?? ""))
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);

  return GestureDetector(
    onTap: () async {
      Get.to(() => WaitingScreenView(
            connectionID: data.sId,
          ));
    },
    child: Container(
      margin: EdgeInsets.only(top: 24.h, bottom: 12.h),
      //height: 164,
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
                              data.userId!,
                              data.requester!,
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
                              data.userId!,
                              data.contact!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (_isRequester && (data.isRequesterAccepted ?? false))
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 12.0.h,
                            left: 24.0.w,
                            right: 24.0.w,
                            bottom: 12.h,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF18C424),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Center(
                            child: Text(
                             "Accepted",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      : (!_isRequester && (data.isContactAccepted ?? false))
                          ? Container(
                              margin: EdgeInsets.only(
                                top: 12.0.h,
                                left: 24.0.w,
                                right: 24.0.w,
                                bottom: 12.h,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFF18C424),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Center(
                                child: Text(
                                  "Accepted",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      width: 100,
                                      alignment: Alignment.center,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF18C424),
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      HTTPManager()
                                          .acceptConnection(
                                              ConnectionRequestModel(
                                                  connectionId: data.sId ?? ""))
                                          .then((value) {
                                        showPluhgDailog2(
                                          Get.context!,
                                          "Success",
                                          "Accepted successfully",
                                          onCLosed: () {
                                            print(
                                                "[Dialogue:OnClose] go to HomeView [2]");
                                            if (value.isRequesterAccepted! &&
                                                value.isContactAccepted!) {
                                              Get.offAll(() => HomeView(
                                                    index: 2,
                                                  ));
                                            } else {
                                              Get.offAll(() => HomeView(
                                                    index: 0,
                                                    connectionTabIndex: 1,
                                                  ));
                                            }
                                          },
                                        );
                                      }).catchError((onError) {
                                        pluhgSnackBar(
                                            'Sorry', onError.toString());
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: Get.size.width * 0.05,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      width: 100,
                                      alignment: Alignment.center,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: Text(
                                        "Decline",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      HTTPManager()
                                          .declineConnection(
                                              ConnectionRequestModel(
                                                  connectionId: data.sId ?? "",
                                                  reason: 'Unknown ??'))
                                          .then((value) {
                                        showPluhgDailog2(
                                          Get.context!,
                                          "Success",
                                          value.message!,
                                          onCLosed: () {
                                            print(
                                                "[Dialogue:OnClose] go to HomeView [2]");
                                            Get.offAll(() => HomeView(
                                                index: 0,
                                                connectionTabIndex: 1));
                                          },
                                        );
                                      }).catchError((onError) {
                                        pluhgSnackBar(
                                            'Sorry', onError.toString());
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                ],
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
            width: 8,
          ),
        ],
      ),
    ),
  );
}

String _getUserName(ConnectionResponseModel data, bool isRequester) {
  String initials = "You've Accepted. Waiting on ";
  if (isRequester) {
    if (data.contact?.refId?.userName?.isNotEmpty ?? false) {
      return "$initials${data.contact?.refId?.userName}";
    } else {
      return "$initials${data.userId?.userName}'s Contact";
    }
  } else {
    if (data.requester?.refId?.userName?.isNotEmpty ?? false) {
      return "$initials${data.requester?.refId?.userName}";
    } else {
      return "$initials${data.userId?.userName}'s Contact";
    }
  }
}
