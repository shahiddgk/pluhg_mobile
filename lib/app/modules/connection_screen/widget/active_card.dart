import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/modules/connection_screen/views/active_connection.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget activeConnectionCard({
  required dynamic data,
  required dynamic prefs,
})  {
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data["created_at"])
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
  return GestureDetector(
    onTap: () {
      Get.to(() => ActiveConnectionScreenView(
          data: data,
          isRequester: prefs.getString("emailAddress").toString() ==
                      data["requester"]["emailAddress"] ||
                  prefs.getString("phoneNumber").toString() ==
                      data["requester"]["phoneNumber"]
              ? true
              : false));
    },
    child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.size.width * 0.04),
        width: Get.width,
        height: Get.size.width * 0.35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xffEBEBEB),
            boxShadow: [
              BoxShadow(blurRadius: 40, color: Color.fromARGB(5, 0, 0, 0))
            ]),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: Get.size.width * 0.35,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(blurRadius: 40, color: Color.fromARGB(5, 0, 0, 0))
                    ]),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: Get.size.width * 0.266,
                        padding: EdgeInsets.all(Get.size.width * 0.018),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(5, 0, 0, 0),
                                  blurRadius: 20)
                            ]),
                        child: Column(
                          children: [
                            Container(
                              width: Get.size.width * 0.18 -
                                  (Get.size.width * 0.036),
                              height: Get.size.width * 0.18 -
                                  (Get.size.width * 0.036),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16)),
                              child: data == null ||
                                      !data["requester"]["refId"]
                                          .containsKey("profileImage") ||
                                      data["requester"]["refId"]
                                              ["profileImage"] ==
                                          null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Get.size.width * 0.042),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: SvgPicture.asset(
                                            "resources/svg/profile.svg"),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Get.size.width * 0.042),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: pluhgColour,
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                                "http://143.198.187.200:3001/uploads/${data["requester"]["refId"]['profileImage'].toString()}"),
                                          )),
                                    ),
                            ),
                            Spacer(),
                            data != null &&
                                    data["requester"].containsKey("userName") &&
                                    data["requester"]["userName"] != null
                                ? Expanded(
                                    child: Text(
                                        "@${data["requester"]["userName"]}",
                                        style: TextStyle(
                                            color: Color(0xff8D8D8D),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  )
                                : Expanded(
                                    child: Text(
                                        data == null
                                            ? "Empty"
                                            : "@${data["requester"]["name"]}",
                                        style: TextStyle(
                                            color: Color(0xff8D8D8D),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                          ],
                        )),
                    SizedBox(
                      width: 22,
                    ),
                    Container(
                        height: Get.size.width * 0.266,
                        width: Get.size.width * 0.18,
                        padding: EdgeInsets.all(Get.size.width * 0.018),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(5, 0, 0, 0),
                                  blurRadius: 20)
                            ]),
                        child: Column(
                          children: [
                            Container(
                              width: Get.size.width * 0.18 -
                                  (Get.size.width * 0.036),
                              height: Get.size.width * 0.18 -
                                  (Get.size.width * 0.036),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16)),
                              child: data == null ||
                                      !data["contact"]["refId"]
                                          .containsKey("profileImage") ||
                                      data["contact"]["refId"]["profileImage"] ==
                                          null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Get.size.width * 0.042),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: pluhgColour,
                                        ),
                                        child: SvgPicture.asset(
                                            "resources/svg/profile.svg"),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Get.size.width * 0.042),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: pluhgColour,
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                                "http://143.198.187.200:3001/uploads/${data["contact"]["refId"]['profileImage'].toString()}"),
                                          )),
                                    ),
                            ),
                            data != null &&
                                    data["contact"].containsKey("userName") &&
                                    data["contact"]["userName"] != null
                                ? Expanded(
                                    child: Text("@${data["contact"]["userName"]}",
                                        style: TextStyle(
                                            color: Color(0xff8D8D8D),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  )
                                : Expanded(
                                    child: Text(
                                        data == null
                                            ? "Contact"
                                            : "@${data["contact"]["name"]}",
                                        style: TextStyle(
                                            color: Color(0xff8D8D8D),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                          ],
                        )),
                  ],
                )),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Plugged by:",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xff898B8B),
                          fontSize: 10)),
                  Text(
                    data == null ? "Pluhg" : "@${data['userId']["userName"]}",
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
              width: 10,
            )
          ],
        )),
  );
}
