import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/connection_screen/controllers/connection_screen_controller.dart';
import 'package:plug/app/widgets/button.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/screens/chat_screen.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:plug/widgets/text_style.dart';

class ActiveConnectionScreenView extends GetView<ConnectionScreenController> {
  final dynamic data;
  final bool isRequester;

  ActiveConnectionScreenView({this.data, required this.isRequester});

  @override
  Widget build(BuildContext context) {
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parseUTC(data["created_at"])
        .toLocal();
    String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SimpleAppBar(
          backButton: true,
          notificationButton: false,
        ),
        body: Padding(
            padding: EdgeInsets.all(20.w),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 20.w),
                      child: Text(
                        "${data['userId']["userName"]} Pluhgged",
                        style: TextStyle(
                          fontSize: 28.sp,
                          color: pluhgColour,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffEBEBEB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 20.w,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 131.72.w,
                                            width: 87.2.w,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          5, 0, 0, 0),
                                                      blurRadius: 20)
                                                ]),
                                            child: cardProfile2(
                                                context,
                                                data["requester"]["refId"],
                                                "Requester")),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        Container(
                                            height: 131.72.w,
                                            width: 87.2.w,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          5, 0, 0, 0),
                                                      blurRadius: 20)
                                                ]),
                                            child: cardProfile2(
                                                context,
                                                data["contact"]["refId"],
                                                "Contact")),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 20.w,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 9.4,
                                      ),
                                      Text("Plugged by:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xff898B8B),
                                              fontSize: 10)),
                                      Text("@${data['userId']["userName"]}",
                                          style: subtitleTextStyle),
                                      SizedBox(height: 8.71.h),
                                      Text(
                                        "Date:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xff898B8B),
                                            fontSize: 10),
                                      ),
                                      Text(
                                          formattedDate
                                              .toString()
                                              .substring(0, 11),
                                          style: subtitleTextStyle),
                                      SizedBox(height: 8.71.h),
                                      Text(
                                        "Time:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xff898B8B),
                                            fontSize: 10),
                                      ),
                                      Text(
                                        formattedDate.toString().substring(12),
                                        style: subtitleTextStyle,
                                      ),
                                    ]),
                              ],
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20.w,
                                ),
                                Text(
                                  "Message From @${data["userId"]["userName"]}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff575858)),
                                ),
                              ],
                            ),
                            //Container(height: 12.h),
                            Container(
                              height: Get.height / 5,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(12.w),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Text(
                                data["message"] == null
                                    ? ""
                                    : "${data["message"]}",
                                textAlign: TextAlign.justify,
                                maxLines: 25,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 14.79,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.33,
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: button3("Close Connection", pluhgRedColour),
                            onTap: () {
                              //show dialog with rating
                              showDialogWithRating(context);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          outline_button("Conversation", onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          senderId: isRequester
                                              ? data["requester"]["refId"]
                                                  ["_id"]
                                              : data["contact"]["refId"]["_id"],
                                          recevierId: !isRequester
                                              ? data["requester"]["refId"]
                                                  ["_id"]
                                              : data["contact"]["refId"]["_id"],
                                        )));
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  void showDialogWithRating(BuildContext context) {
    showPluhgRatingDailog(context, "Close connection",
        "To close this connection, rate @${data['userId']["userName"]}’s connection recomendation",
        onCLosed: (value) {
      print("Rating value $value");
    });
  }
}
