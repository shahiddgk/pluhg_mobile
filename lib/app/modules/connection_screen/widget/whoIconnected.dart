import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/modules/recommendation_screen/views/recommended_connection_screen.dart';
import 'package:plug/widgets/connection_profile_card.dart';

Widget whoIConnectedCard({
  required dynamic data,
  required dynamic prefs,
}) {
  var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
      .parseUTC(data == null ? "22:03:2021 12:18 Tc" : data["created_at"])
      .toLocal();
  String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
  return GestureDetector(
    onTap: () {
      Get.to(() => RecommendedScreenView(connectionID: data['_id'],));
    },
    child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        height: 145.98,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffEBEBEB),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 145.98,
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
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 96,
                            width: 84,
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
                            height: 96,
                            width: 84,
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
                    Container(
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                          color: data["isRequesterAccepted"] &&
                                  data["isContactAccepted"]
                              ? Color(0xff18C424)
                              : Color(0xffBFA124),
                          borderRadius: BorderRadius.circular(28)),
                      child: Center(
                          child: Text(
                              data["isRequesterAccepted"] &&
                                      data["isContactAccepted"]
                                  ? "Accepted"
                                  : "Pending",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400))),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
        )),
  );
}