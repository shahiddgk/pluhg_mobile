import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';

class NotifIcon extends StatelessWidget {
  const NotifIcon({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return   IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => NotificationScreenView()));
      },
      icon: SvgPicture.asset("assets/images/notification.svg",
            color: Color(0xff080F18)
      )
    );
  }
}
