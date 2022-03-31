import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/screens/waiting_connection_screen.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

Widget waitingConnectionCard({
  required dynamic data,
  required Rx<User> user,
  required VoidCallback onRemoveCallBack,
}) {
  APICALLS api = APICALLS();
  RxBool responded = false.obs;
  bool _isRequester = user.value.compareEmail(data["requester"]["contact"]) ||
      user.value.comparePhone(data["requester"]["contact"]);

  responded.value =
      _isRequester ? data["isRequesterAccepted"] : data["isContactAccepted"];

  var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data["created_at"])
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);

  return Obx(
    () => GestureDetector(
      onTap: () async{
        var returnData = await Get.to(() => WaitingConnectionScreen(
            data: data,
        ));

       if(returnData){
         onRemoveCallBack();
       }

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
                    responded.value
                        ? Container(
                            height: 28.h,
                            margin: EdgeInsets.only(
                              top: 12.0.h,
                              left: 24.0.w,
                              right: 24.0.w,
                              bottom: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFA4A4A4),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: Text(
                                "Waiting...",
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
                                    responded.value = await api.acceptConnectionRequest(
                                      connectionID: data["_id"],
                                      context: Get.context!,
                                    );
                                    onRemoveCallBack();
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
                                    responded.value = await api.declineConnectionRequest(
                                      connectionID: data["_id"],
                                      context: Get.context!,
                                      reason: 'Unknown ??',
                                    );
                                    onRemoveCallBack();
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
              width: 8,
            ),
          ],
        ),
      ),
    ),
  );
}

