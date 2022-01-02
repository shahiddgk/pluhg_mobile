import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/modules/splash_screen/controllers/notification_controller.dart';

class NotifIcon extends StatelessWidget {
  NotifIcon({Key? key}) : super(key: key);

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
       IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (contex) => NotificationScreenView()));
          },
          icon: SvgPicture.asset(controller.receivedNotification.value?"assets/images/emoji.svg":"assets/images/notification.svg",
              color: Color(0xff080F18))),
    );
  }
}
