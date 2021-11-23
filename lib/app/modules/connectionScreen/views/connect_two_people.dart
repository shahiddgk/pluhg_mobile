import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/modules/connectionScreen/controllers/connect_two.dart';
import 'package:plug/app/modules/contact/views/contact_view.dart';
import 'package:plug/app/modules/notificationScreen/views/notification_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ConnectScreenView extends GetView<ConnecTwoScreenController> {
  final dynamic data, token, userId;
  ConnectScreenView({this.data, this.token, this.userId});
  final controller = Get.put(ConnecTwoScreenController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.getInfo(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                width: Get.width.w,
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      widthFactor: 13,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => NotificationScreenView());
                        },
                        child: Icon(Icons.notifications_outlined,
                            color: Color(0xff080F18)),
                      ),
                    ),
                    SizedBox(
                      height: 83,
                    ),
                    Text(
                      "Connect Two People",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 30,
                          color: pluhgColour,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 73),
                    Center(
                      child: Container(
                        width: Get.width.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    Get.to(() => ContactView(
                                          who: "Requester",
                                          token: prefs
                                              .getString("token")
                                              .toString(),
                                          userID: prefs
                                              .getString("userID")
                                              .toString(),
                                        ));
                                  },
                                  child: SvgPicture.asset(
                                    "resources/svg/requester.svg",
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              "resources/svg/middle.svg",
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    Get.to(() => ContactView(
                                          who: "Requester",
                                          token: prefs
                                              .getString("token")
                                              .toString(),
                                          userID: prefs
                                              .getString("userID")
                                              .toString(),
                                        ));
                                  },
                                  child: SvgPicture.asset(
                                    "resources/svg/contact.svg",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                        child: controller.isLoading.value
                            ? Text("Loading...")
                            : controller.profileDetails['data'] == null
                                ? Container()
                                : Container(
                                    width: 51.69,
                                    height: 48.88,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "http://143.198.187.200:3001/uploads/${controller.profileDetails['data']['profileImage'].toString()}"))),
                                  )),
                    Center(child: Text("The Pluhg")),
                    SizedBox(
                      height: 73,
                    ),
                    Center(
                        child: SvgPicture.asset(
                      "resources/svg/dots.svg",
                    )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
