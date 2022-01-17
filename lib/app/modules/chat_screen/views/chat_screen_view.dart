import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
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
      appBar: SearchAppBar(
        searchController,
        (value) {
          controller.search.value = value;
          print(controller.search.value);
          print(controller.users_.length);

        },
        messages_page: true,
      ),
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
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: controller.size.height * 0.02),
            if (controller.users_.length == 0)
              Center(child: Text('No message yet!')),
            if (controller.users_.length != 0)
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.users_.length,
                itemBuilder: (ctx, i) => InkWell(
                        onTap: () {
                          //Gi to chat screen
                          Get.to(() => ChatScreen(
                              username_receiver: controller.users_[i].userName,
                              name_receiver: controller.users_[i].name,
                              profile_receiver: APICALLS.imageBaseUrl +
                                  controller.users_[i].profileImage!,
                              senderId: controller.users_[i].senderId,
                              recevierId: controller.users_[i].recevierId));
                        }, // get last message item
                        child: getMainChatItem(controller.users_[i]),
                      )
                    ,
              ),
          ],
        ),
      ),
    );
  }
}
