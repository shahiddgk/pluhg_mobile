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
    print("[ChatScreenView] build");
    return Obx(() => Scaffold(
          appBar: SearchAppBar(
            searchController,
            controller.searchMessages,
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
                if (controller.users.length == 0) Center(child: Text('No message yet!')),
                if (controller.users.length != 0)
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.users.length,
                    itemBuilder: (ctx, i) => InkWell(
                      onTap: () {
                        //Gi to chat screen
                        Get.to(() => ChatScreen(
                            username_receiver: controller.users[i].userName,
                            name_receiver: controller.users[i].name,
                            profile_receiver: APICALLS.imageBaseUrl + controller.users[i].profileImage!,
                            senderId: controller.users[i].senderId,
                            recevierId: controller.users[i].recevierId,
                            clearUnReadMessageCount: (){


                              print('CALL BACK CALL${controller.total_unread_messages.value}');

                              var tempUser = controller.users[i];
                              var temp = tempUser.unReadCount;

                              tempUser.unReadCount = 0;
                              var index = controller.users.removeAt(i);
                              controller.users.insert(i, tempUser);
                              //controller.users[i].unReadCount = 0;
                              if(temp > 0) {
                                controller.total_unread_messages.value = (controller.total_unread_messages.value - temp).toInt();
                              }
                              /*controller.users.clear();
                              controller.socket.close();
                              controller.connect();*/


                              print('CALL BACK END CALL }${controller.total_unread_messages.value}');


                            },
                        ));
                      }, // get last message item
                      child: getMainChatItem(controller.users[i]),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
