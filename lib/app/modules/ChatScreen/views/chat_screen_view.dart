import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/modules/ChatScreen/views/chat_messages.dart';
import 'package:plug/app/modules/notificationScreen/views/notification_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/screens/chat_screen.dart';

import '../controllers/chat_screen_controller.dart';

class ChatScreenView extends GetView<ChatScreenController> {
  final controller = Get.put(ChatScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: controller.size.height * 0.05),
            ListTile(
              // visualDensity: VisualDensity(horizontal: 4),
              leading: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF080F18),
                ),
              ),
              trailing: InkWell(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => NotificationScreenView());
                  },
                  child: Icon(Icons.notifications_outlined,
                      color: Color(0xff080F18)),
                ),
              ),
              title: Container(
                height: 40,
                width: controller.size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(39),
                  color: Color(0xFFEBEBEB),
                  // color: Colors.blue,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(39),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 0,
                    ),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.all(0),
                        isDense: false,
                        focusColor: Colors.black,
                        border: InputBorder.none,
                        prefixIconConstraints: BoxConstraints(
                          minHeight: 15,
                          maxHeight: 15,
                          minWidth: 25,
                          maxWidth: 25,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SvgPicture.asset(
                            'resources/svg/search1.svg',
                            height: 15,
                            width: 15,
                          ),
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Color(0xFF080F18),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: controller.size.height * 0.016),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Messages',
                style: TextStyle(
                  color: pluhgColour,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: controller.size.height * 0.02),
            if (controller.users.length == 0)
              Center(
                child: Text('No Messages Yet.', style: TextStyle(fontSize: 16)),
              ),
            if (controller.users.length != 0)
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.users.length,
                itemBuilder: (ctx, i) => InkWell(
                  onTap: () {
                    Get.to(() => ChatScreen(
                        senderId: controller.users[i].senderId,
                        recevierId: controller.users[i].recevierId));
                  },
                  child: ListTile(
                    tileColor: controller.users[i].isRead
                        ? Colors.transparent
                        : Color(0xFFF9F9F9),
                    // tileColor: Colors.blue,
                    horizontalTitleGap: 10,
                    contentPadding: EdgeInsets.only(left: 18, right: 18),
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundImage: controller.users[i].profileImage != null
                          ? AssetImage(controller.users[i].profileImage!)
                          : null,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.users[i].time,
                          style: TextStyle(
                            color: Color(0xFF242037),
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (!controller.users[i].isRead) SizedBox(height: 6),
                        if (!controller.users[i].isRead)
                          CircleAvatar(
                            radius: 9,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      controller.users[i].name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF242037),
                      ),
                    ),
                    subtitle: Text(
                      controller.users[i].message,
                      style: TextStyle(
                        color: Color(0xFF242037),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
