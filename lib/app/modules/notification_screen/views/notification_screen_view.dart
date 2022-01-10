import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/models/notification_response.dart';

import '../controllers/notification_screen_controller.dart';

class NotificationScreenView extends GetView<NotificationScreenController> {
  final controller = Get.put(NotificationScreenController());
  @override
  Widget build(BuildContext context) {
    Size size = Get.size;
    return Scaffold(
      body: FutureBuilder<dynamic>(
          future: controller.getNotificationList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: pluhgProgress(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("No Notification yet"),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error Encountered, Sorry"),
              );
            } else {
              NotificationResponse notificationResponse = snapshot.data;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Color(0xFF080F18)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          color: pluhgColour,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(height: size.height * 0.00007),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: notificationResponse.data.length,
                        itemBuilder: (ctx, i) => Container(
                          color: Color(0xFFF9F9F9),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CircleAvatar(
                                radius: 50 / 2,
                                backgroundImage: notificationResponse.data[i].userId.profileImage.isEmpty
                                    ? SvgPicture.asset(
                                            "resources/svg/profile.svg")
                                        as ImageProvider
                                    : NetworkImage(
                                        APICALLS.imageBaseUrl+'${notificationResponse.data[i].userId.profileImage}'),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width - 36 - 45,
                                        child: Text(
                                          notificationResponse.data[i].notificationMsg.body
                                              .toString(),
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.getTimeDifference(notificationResponse.data[i].createdAt),
                                            style: TextStyle(
                                              color: Color(0xFF8E8E93),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              controller.read.value = true;
                                            },
                                            child: Text(
                                              notificationResponse.data[i].status == 1
                                                  ? "Seen"
                                                  : 'Mark as Read',
                                              style: TextStyle(
                                                color: pluhgColour,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
