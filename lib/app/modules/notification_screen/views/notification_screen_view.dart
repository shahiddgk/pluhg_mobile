import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/models/notification_response.dart';
import 'package:plug/widgets/image.dart';

import '../../../values/colors.dart';
import '../controllers/notification_screen_controller.dart';

class NotificationScreenView extends GetView<NotificationScreenController> {
  final controller = Get.put(NotificationScreenController());

  @override
  Widget build(BuildContext context) {
    Size size = Get.size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        backButton: true,
        notificationButton: false,
      ),
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:  notificationResponse.data.length,
                        itemBuilder: (ctx, i) => Slidable(
                            // Specify a key if the Slidable is dismissible.
                            key: const ValueKey(0),

                            // The start action pane is the one at the left or the top side.
                            endActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),

                              // A pane can dismiss the Slidable.
                              // dismissible:
                              //     DismissiblePane(onDismissed: () {}),

                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                Obx(() {
                                    final notification =
                                    notificationResponse.data[i];
                                    final isRead = controller
                                        .read[notification.id] ??
                                        notification.status == 1;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          if (!isRead) {
                                            final status =
                                                await controller
                                                .markAsRead(
                                                notification);
                                            notificationResponse.data[i]
                                                .status = status ? 1 : 0;
                                            // this.controller.update();
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          "assets/svg/notification_read.svg",
                                          width: 50.w,
                                          height: 50.h,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      "assets/svg/notification_delete.svg",
                                      width: 50.w,
                                      height: 50.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: i == 0
                                      ? AppColors.pluhgYellowColourLight
                                      : i == 1
                                          ? AppColors.pluhgRedLight
                                          : i == 2
                                              ? AppColors.pluhgGreenLight
                                              : AppColors.pluhgWhite,
                                  border: Border.all(
                                    color: i == 3
                                        ? AppColors.pluhgGreyColour
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    notificationResponse
                                        .data[i].userId.profileImage.isEmpty
                                        ? SvgPicture.asset(
                                        "resources/svg/profile.svg")
                                        : cachedNetworkImageWidget(
                                      imageUrl: APICALLS.imageBaseUrl +
                                          '${notificationResponse.data[i].userId.profileImage}',
                                      width: 50.w,
                                      height: 50.w,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notificationResponse
                                                  .data[i].notificationMsg.title
                                                  .toString(),
                                              //"Connection recommendation",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: notificationResponse.data[i].status == 0
                                                    ? AppColors
                                                        .pluhgOrangeColour
                                                    : i == 1
                                                        ? AppColors
                                                            .pluhgRedDark
                                                        : i == 2
                                                            ? AppColors
                                                                .pluhgGreenDark
                                                            : AppColors
                                                                .pluhgMenuBlackColour,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              notificationResponse
                                                  .data[i].notificationMsg.body
                                                  .toString(),
                                              //"GoldenGril has recommended a recommendation between you and Johnny B. Quick.",
                                              maxLines: 4,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors
                                                    .pluhgGrayColour3,
                                                fontSize: 14,
                                                //fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Align(
                                              alignment:
                                                  Alignment.bottomRight,
                                              child: Text(
                                                controller.getTimeDifference(
                                                    notificationResponse
                                                        .data[i].createdAt),
                                                // "Just Now",
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors
                                                      .pluhgGrayColour3,
                                                  fontSize: 14,
                                                  //fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))),
                    ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: notificationResponse.data.length,
                      itemBuilder: (ctx, i) => Container(
                        color: Color(0xFFF9F9F9),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ///OLD code
                            /*CircleAvatar(
                              radius: 50 / 2,
                              backgroundImage: notificationResponse.data[i].userId.profileImage.isEmpty
                                  ? SvgPicture.asset(
                                          "resources/svg/profile.svg")
                                      as ImageProvider
                                  : NetworkImage(APICALLS.imageBaseUrl + '${notificationResponse.data[i].userId.profileImage}'),
                            ),*/

                            CircleAvatar(
                              radius: 50 / 2,
                              child: notificationResponse
                                      .data[i].userId.profileImage.isEmpty
                                  ? SvgPicture.asset(
                                      "resources/svg/profile.svg")
                                  : cachedNetworkImageWidget(
                                      imageUrl: APICALLS.imageBaseUrl +
                                          '${notificationResponse.data[i].userId.profileImage}',
                                      width: 50,
                                      height: 50,
                                    ),
                            ),

                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: size.width - 36 - 45,
                                      child: Text(
                                        notificationResponse
                                            .data[i].notificationMsg.body
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
                                          controller.getTimeDifference(
                                              notificationResponse
                                                  .data[i].createdAt),
                                          style: TextStyle(
                                            color: Color(0xFF8E8E93),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Obx(
                                          () {
                                            final notification =
                                                notificationResponse.data[i];
                                            final isRead = controller
                                                    .read[notification.id] ??
                                                notification.status == 1;

                                            return GestureDetector(
                                              onTap: () async {
                                                if (!isRead) {
                                                  final status =
                                                      await controller
                                                          .markAsRead(
                                                              notification);
                                                  notificationResponse.data[i]
                                                      .status = status ? 1 : 0;
                                                  // this.controller.update();
                                                }
                                              },
                                              child: Text(
                                                isRead
                                                    ? "Seen"
                                                    : 'Mark as Read',
                                                style: TextStyle(
                                                  color: pluhgColour,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            );
                                          },
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
        },
      ),
    );
  }

  markAsRead(BuildContext context)  {
  }
}
