import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/screens/waiting_connection_screen.dart';
import 'package:plug/widgets/connection_profile_card.dart';

Widget waitingConnectionCard({
  required dynamic data,
  required dynamic prefs,
}) {
  RxBool responded = false.obs;
  bool _isRequester = prefs.getString(prefuseremail) != null
      ? prefs.getString(prefuseremail) == data["requester"]["contact"]
      : prefs.getString(prefuserphone) == data["requester"]["contact"];

  if (_isRequester) {
    responded.value = data["isRequesterAccepted"];
  } else {
    responded.value = data["isContactAccepted"];
  }

  var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data["created_at"])
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
  return Obx(() => GestureDetector(
      onTap: () {
        Get.to(() => WaitingConnectionScreen(data: data));
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: Get.size.width * 0.04),
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
                      boxShadow: [
                        BoxShadow(blurRadius: 40, color: Colors.black12)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                width: 84,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 20)
                                    ]),
                                child: card(
                                    Get.context!, data["requester"]["refId"])),
                            Container(
                                width: 84.0,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 20)
                                    ]),
                                child: card(
                                    Get.context!, data["contact"]["refId"])),
                          ],
                        ),
                      ),
                      responded.value
                          ? SizedBox()
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
                                      _callApi(data, prefs, responded, true);
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
                                      _callApi(data, prefs, responded, false);
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(children: [
                SizedBox(
                  height: 9.4,
                ),
                Text("Plugged by:",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Color(0xff898B8B),
                        fontSize: 10)),
                Text(
                  data['userId']["userName"] == null
                      ? data['userId']["name"] ?? ""
                      : "@" + data['userId']["userName"],
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: Color(0xff575858)),
                ),
                SizedBox(height: 4.71),
                Text(
                  "Date:",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff898B8B),
                      fontSize: 10),
                ),
                Text(
                  formattedDate.toString().substring(0, 11),
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: Color(0xff575858)),
                ),
                SizedBox(height: 4.71),
                Text(
                  "Time:",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff898B8B),
                      fontSize: 10),
                ),
                Text(
                  formattedDate.toString().substring(12),
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: Color(0xff575858)),
                ),
              ]),
              SizedBox(
                width: 8,
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
          ))));
}

void _callApi(var data, dynamic prefs, responded, bool activeDecline) async {
  APICALLS apicalls = APICALLS();
  responded.value = await apicalls.respondToConnectionRequest(
      connectionID: data["_id"],
      contact: prefs.getString(prefuseremail),
      context: Get.context!,
      isContact: data["contact"]["refId"]["_id"].toString() ==
              prefs.getString(prefuserid)
          ? true
          : false,
      plugID: data["userId"]["_id"],
      isAccepting: activeDecline,
      isRequester: data["requester"]["refId"]["_id"].toString() ==
              prefs.getString(prefuserid)
          ? true
          : false);
}
