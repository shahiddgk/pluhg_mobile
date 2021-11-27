import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/screens/Waiting_Connection_Screen.dart';
import 'package:plug/widgets/connection_profile_card.dart';

Widget waitingConnectionCard({
  required dynamic data,
  required dynamic prefs,
}) {
  RxBool responded = false.obs;
  bool _isRequester = prefs.getString("emailAddress") != null
      ? prefs.getString("emailAddress") == data["requester"]["contact"]
      : prefs.getString("phoneNumber") == data["requester"]["contact"];

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
          width: 340.33,
          height: 145.98,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xffEBEBEB),
          ),
          child: Row(
            children: [
              Container(
                height: 145.98,
                width: 180,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 40, color: Color.fromARGB(5, 0, 0, 0))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 85.54,
                            width: 67.99,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(5, 0, 0, 0),
                                      blurRadius: 20)
                                ]),
                            child:
                                card(Get.context!, data["requester"]["refId"])),
                        SizedBox(
                          width: 22,
                        ),
                        Container(
                            height: 85.54,
                            width: 67.99,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(5, 0, 0, 0),
                                      blurRadius: 20)
                                ]),
                            child:
                                card(Get.context!, data["contact"]["refId"])),
                      ],
                    )),
                    responded.value
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.only(
                              top: Get.size.width * 0.05,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width: 64.58,
                                    alignment: Alignment.center,
                                    height: 20,
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
                                    print(prefs.getString("userID"));
                                    APICALLS apicalls = APICALLS();
                                    responded.value = await apicalls
                                        .respondToConnectionRequest(
                                            connectionID: data["_id"],
                                            contact:
                                                prefs.getString("emailAddress"),
                                            // !=
                                            //         null
                                            //     ? prefs
                                            //         .getString("emailAddress")
                                            //     : prefs
                                            //         .getString("phoneNumber"),
                                            isContact: data["contact"]["refId"]
                                                            ["_id"]
                                                        .toString() ==
                                                    prefs.getString("userID")
                                                ? true
                                                : false,
                                            context: Get.context!,
                                            plugID: data["userId"]["_id"],
                                            isAccepting: true,
                                            isRequester: data["requester"]
                                                            ["refId"]["_id"]
                                                        .toString() ==
                                                    prefs.getString("userID")
                                                ? true
                                                : false);
                                    print("victorhez");
                                    print(prefs.getString("userID"));
                                    print(data["requester"]["refId"]["_id"]
                                        .toString());
                                    print(data["contact"]["refId"]["_id"]
                                        .toString());
                                  },
                                ),
                                SizedBox(
                                  width: Get.size.width * 0.05,
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 64.58,
                                    alignment: Alignment.center,
                                    height: 20,
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
                                    APICALLS apicalls = APICALLS();
                                    responded.value = await apicalls
                                        .respondToConnectionRequest(
                                            connectionID: data["_id"],
                                            contact:
                                                prefs.getString("emailAddress"),
                                            //  !=
                                            //         null
                                            //     ? prefs
                                            //         .getString("emailAddress")
                                            //     : prefs
                                            //         .getString("phoneNumber"),
                                            context: Get.context!,
                                            isContact: data["contact"]["refId"]
                                                            ["_id"]
                                                        .toString() ==
                                                    prefs.getString("userID")
                                                ? true
                                                : false,
                                            plugID: data["userId"]["_id"],
                                            isAccepting: false,
                                            isRequester: data["requester"]
                                                            ["refId"]["_id"]
                                                        .toString() ==
                                                    prefs.getString("userID")
                                                ? true
                                                : false);
                                  },
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                width: 3,
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
                  "@${data['userId']["userName"]}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
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
                      fontWeight: FontWeight.w400,
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
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xff575858)),
                ),
              ]),
              Spacer(),
              Center(
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xff575858),
                ),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ))));
}
