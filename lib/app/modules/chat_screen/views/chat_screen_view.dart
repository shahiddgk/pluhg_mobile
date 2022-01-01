import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/search_app_bar.dart';
import 'package:plug/screens/chat/chat_screen.dart';
import 'package:plug/widgets/main_chat_widget.dart';

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
            getMainChatList()
       /*     SizedBox(height: controller.size.height * 0.02),
            if (controller.users.length == 0) getMainChatList(),
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
                  child: getMainChatList(),
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
