import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/connection_screen/controllers/connect_two.dart';
import 'package:plug/app/modules/contact/views/contact_view.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/widgets/image.dart';
import 'package:plug/widgets/notif_icon.dart';
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              actions: [NotifIcon()],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      "Connect Two People",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 30,
                          color: pluhgColour,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 54),
                    Container(
                      width: Get.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              Get.to(() => ContactView(
                                    who: "Requester",
                                    token: prefs.getString("token").toString(),
                                    userID:
                                        prefs.getString("userID").toString(),
                                  ));
                            },
                            child: SizedBox(
                              width: Get.width / 3 - 18,
                              child: SvgPicture.asset(
                                "resources/svg/requester.svg",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 3,
                            child: SvgPicture.asset(
                              "resources/svg/middle.svg",
                              width: Get.width / 3,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              Get.to(() => ContactView(
                                    who: "Requester",
                                    token: prefs.getString("token").toString(),
                                    userID:
                                        prefs.getString("userID").toString(),
                                  ));
                            },
                            child: SizedBox(
                              width: Get.width / 3 - 18,
                              child: SvgPicture.asset(
                                "resources/svg/contact.svg",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                        child: controller.isLoading.value
                            ? defaultImage()
                            : controller.profileDetails['data'] == null
                                ? defaultImage()
                                : Container(
                                    width: 51.69,
                                    height: 48.88,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: networkImage(50, 52,
                                        "${APICALLS.imageBaseUrl}${controller.profileDetails['data']['profileImage'].toString()}"),
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
