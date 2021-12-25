import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/search_app_bar.dart';
import 'package:plug/screens/chat/chat_screen.dart';

import '../controllers/chat_screen_controller.dart';

class ChatScreenView extends GetView<ChatScreenController> {
  final controller = Get.put(ChatScreenController());
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(searchController,(value){}),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      username_receiver: "",
                        name_receiver: controller.users[i].name,
                        profile_receiver:  controller.users[i].profileImage! ,
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
