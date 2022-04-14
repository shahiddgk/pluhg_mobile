import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/home/controllers/home_controller.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/modules/splash_screen/controllers/notification_controller.dart';
import 'package:plug/app/values/colors.dart';

class NotifIcon extends StatelessWidget {
  NotifIcon({Key? key}) : super(key: key);

  final controller = Get.put(NotificationController());

  final homeController = Get.put(HomeController());


  @override
  Widget build(BuildContext context) {

    return Obx((){
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Stack(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => NotificationScreenView()));
                },
                icon: SvgPicture.asset(
                   "assets/images/notification.svg",
                ),
            ),

            if(homeController.notificationCount.value != 0)
            Positioned(
              top: 4,
              right: 6,
              child:  Container(
                decoration: BoxDecoration(color: AppColors.pluhgColour, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      '${homeController.notificationCount.value}',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });

    return Obx(
      () => IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (contex) => NotificationScreenView()));
          },
          icon: SvgPicture.asset(
            controller.receivedNotification.value
                ? "assets/images/ic_red_notification.svg"
                : "assets/images/notification.svg",
          )),
    );
  }
}
