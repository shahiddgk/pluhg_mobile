import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/connection_screen/controllers/connect_two.dart';
import 'package:plug/app/modules/contact/views/contact_view.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/widgets/image.dart';
import 'package:plug/widgets/notif_icon.dart';

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
              elevation: 0,
              actions: [NotifIcon()],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 17.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 54.h),
                    Text(
                      "Connect Two People",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 35.sp, color: pluhgColour, fontWeight: FontWeight.w700, height: 1.h),
                    ),
                    SizedBox(height: 54.h),
                    Container(
                      width: Get.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              User user = await UserState.get();
                              Get.to(() => ContactView(who: "Requester", token: user.token, userID: user.id));
                            },
                            child: Container(
                              width: 85.w,
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(blurRadius: 40, color: Colors.black12)],
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: SvgPicture.asset(
                                "resources/svg/requester.svg",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 160.w,
                            child: SvgPicture.asset(
                              "resources/svg/middle.svg",
                              width: 160.w,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              User user = await UserState.get();
                              Get.to(() => Center(
                                    child: ContactView(
                                      who: "Requester",
                                      token: user.token,
                                      userID: user.id,
                                    ),
                                  ));
                            },
                            child: Container(
                              width: 85.w,
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(blurRadius: 40, color: Colors.black12)],
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: SvgPicture.asset(
                                "resources/svg/contact.svg",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: controller.isLoading.value || controller.profileDetails['data'] == null
                          ? defaultImage()
                          : Container(
                              width: 54.w,
                              height: 54.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: networkImage(54.w, 54.w,
                                    "${APICALLS.imageBaseUrl}${controller.profileDetails['data']['profileImage'].toString()}"),
                              )),
                    ),
                    SizedBox(height: 8.h),
                    Center(child: Text("The Pluhg")),
                    SizedBox(height: 73.h),
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
