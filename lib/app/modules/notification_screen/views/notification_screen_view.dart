import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/models/notification_response.dart';

import '../../../values/colors.dart';
import '../../connection_screen/controllers/connection_screen_controller.dart';
import '../../connection_screen/views/active_connection.dart';
import '../../recommendation_screen/views/recommended_connection_screen.dart';
import '../../waiting_screen/views/waiting_connection_screen.dart';
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
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error Encountered, Sorry"),
            );
          } else {
            return snapshot.data.value.values.length == 0
                ? Center(
                    child: Text("No Notification yet"),
                  )
                : Padding(
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
                          Obx(() {
                            return ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.data.value.values.length,
                                itemBuilder: (ctx, i) {
                                  final notification =
                                      controller.data.value.values[i];
                                  final isRead =
                                      notification.status == 1 ? true : false;
                                  // controller.read[notification.sId] ??
                                  //     notification.status == 1;
                                  return Slidable(
                                      key: ValueKey(
                                          controller.data.value.values[i].sId),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () async {
                                                if (!isRead) {
                                                  print("mark read clicked");
                                                  controller.markAsRead(
                                                      i, notification);
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                "assets/svg/notification_read.svg",
                                                width: 50.w,
                                                height: 50.h,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                controller.deleteNotification(
                                                    i, notification);
                                              },
                                              child: SvgPicture.asset(
                                                "assets/svg/notification_delete.svg",
                                                width: 50.w,
                                                height: 50.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (!isRead) {
                                            print("mark read clicked");
                                            controller.markAsRead(
                                                i, notification);
                                          }
                                          if (controller.user.value.id ==
                                              controller
                                                  .data
                                                  .value
                                                  .values[i]
                                                  .connectionResponseModel
                                                  ?.userId
                                                  ?.sId) {
                                            Get.to(
                                              () => RecommendedScreenView(
                                                connectionID: controller
                                                    .data
                                                    .value
                                                    .values[i]
                                                    .connectionResponseModel
                                                    ?.sId,
                                              ),
                                            );
                                          } else if ((controller
                                                      .data
                                                      .value
                                                      .values[i]
                                                      .connectionResponseModel
                                                      ?.isRequesterAccepted ??
                                                  false) &&
                                              (controller
                                                      .data
                                                      .value
                                                      .values[i]
                                                      .connectionResponseModel
                                                      ?.isContactAccepted ??
                                                  false)) {
                                            Get.to(
                                              () => ActiveConnectionScreenView(
                                                data: controller
                                                    .data
                                                    .value
                                                    .values[i]
                                                    .connectionResponseModel!,
                                                isRequester: controller
                                                    .user.value
                                                    .compareId(
                                                        '${controller.data.value.values[i].connectionResponseModel?.requester?.refId?.sId}'),
                                                refreshActiveConnection: () {
                                                  Get.put(ConnectionScreenController())
                                                      .activeData();
                                                },
                                              ),
                                            );
                                          } else {
                                            print(controller
                                                .data
                                                .value
                                                .values[i]
                                                .connectionResponseModel
                                                ?.sId??"");
                                            Get.to(() => WaitingScreenView(
                                                  connectionID: controller
                                                      .data
                                                      .value
                                                      .values[i]
                                                      .connectionResponseModel
                                                      ?.sId??"",
                                                ));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: isRead
                                                  ? AppColors.pluhgWhite
                                                  : getBackgroundColor(
                                                      controller
                                                          .data
                                                          .value
                                                          .values[i]
                                                          .notificationMsg
                                                          ?.type),
                                              border: Border.all(
                                                color: isRead
                                                    ? AppColors.pluhgGreyColour
                                                    : Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                isRead
                                                    ? SvgPicture.asset(
                                                        "assets/svg/logo_small_grey.svg")
                                                    : SvgPicture.asset(
                                                        "assets/svg/logo_small_blue.svg"),
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          controller
                                                                  .data
                                                                  .value
                                                                  .values[i]
                                                                  .notificationMsg
                                                                  ?.title ??
                                                              "",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            color: isRead
                                                                ? AppColors
                                                                    .pluhgMenuBlackColour
                                                                : getTextColor(
                                                                    controller
                                                                        .data
                                                                        .value
                                                                        .values[
                                                                            i]
                                                                        .notificationMsg
                                                                        ?.type),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          controller
                                                                  .data
                                                                  .value
                                                                  .values[i]
                                                                  .notificationMsg
                                                                  ?.body ??
                                                              "",
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .pluhgGrayColour3,
                                                            fontSize: 14,
                                                            //fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            controller.getTimeDifference(
                                                                controller
                                                                        .data
                                                                        .value
                                                                        .values[
                                                                            i]
                                                                        .createdAt ??
                                                                    ""),
                                                            // "Just Now",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                        ),
                                      ));
                                });
                          }),
                        ],
                      ),
                    ),
                  );
          }
        },
      ),
    );
  }

  getTextColor(String? type) {
    if (type == kindOf.ACCEPT || type == kindOf.ACCEPT_REPLY) {
      return AppColors.pluhgGreenDark;
    } else if (type == kindOf.DECLINE || type == kindOf.DECLINE_REPLY) {
      return AppColors.pluhgRedDark;
    } else if (type == kindOf.RECOMMENDATION) {
      return AppColors.recommendedText;
    } else {
      return AppColors.pluhgMenuBlackColour;
    }
  }

  getBackgroundColor(String? type) {
    if (type == kindOf.ACCEPT || type == kindOf.ACCEPT_REPLY) {
      return AppColors.pluhgGreenLight;
    } else if (type == kindOf.DECLINE || type == kindOf.DECLINE_REPLY) {
      return AppColors.pluhgRedLight;
    } else if (type == kindOf.RECOMMENDATION) {
      return AppColors.recommendedBackground;
    } else {
      return AppColors.pluhgWhite;
    }
  }

  markAsRead(BuildContext context) {}
}
