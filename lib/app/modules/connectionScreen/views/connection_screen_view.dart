import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:plug/app/modules/connectionScreen/widget/active_card.dart';
import 'package:plug/app/modules/connectionScreen/widget/tab.dart';
import 'package:plug/app/modules/connectionScreen/widget/waiting_card.dart';
import 'package:plug/app/modules/connectionScreen/widget/whoIconnected.dart';
import 'package:plug/app/modules/notificationScreen/views/notification_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';

import '../controllers/connection_screen_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectionScreenView extends GetView<ConnectionScreenController> {
  final controller = Get.put(ConnectionScreenController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Color(0xffEBEBEB),
            borderRadius: BorderRadius.circular(39.r),
          ),
          child: TextFormField(
            controller: searchController,
            onChanged: (value) {},
            decoration: InputDecoration(
                hintText: "search contact..",
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: Color(0xff080F18),
                ),
                suffixIcon: Visibility(
                    visible: searchController.text.isNotEmpty,
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        searchController.clear();
                      },
                    )),

                // labelText: "Bill",
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: pluhgMenuBlackColour,
                    fontWeight: FontWeight.w300)),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (contex) => NotificationScreenView()));
            },
            child: Icon(Icons.notifications_outlined, color: Color(0xff080F18)),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19.81.w),
                  child: Text(
                    "Connections",
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: pluhgColour,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.5.h,
                ),
                Container(
                  width: Get.width * 0.90,
                  height: 39.99,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(53),
                      color: Color(0xffEBEBEB)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.currentIndex.value = 0;
                          },
                          child: connectionTab(
                              "Active",
                              controller.currentIndex.value == 0
                                  ? true
                                  : false),
                        ),
                        InkWell(
                            onTap: () {
                              controller.currentIndex.value = 1;
                            },
                            child: connectionTab(
                                "Waiting",
                                controller.currentIndex.value == 1
                                    ? true
                                    : false)),
                        InkWell(
                            onTap: () {
                              controller.currentIndex.value = 2;
                            },
                            child: connectionTab(
                                "Who I Connected",
                                controller.currentIndex.value == 2
                                    ? true
                                    : false))
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                    future: controller.currentIndex.value == 0
                        ? controller.activeData()
                        : controller.currentIndex.value == 1
                            ? controller.waitingData()
                            : controller.whoIconnectedData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none &&
                          snapshot.hasData == false) {
                        //print('project snapshot data is: ${projectSnap.data}');
                        return Center();
                      }
                      return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.currentIndex.value == 0
                                  ? snapshot.hasData != false
                                      ? controller.activeList.value
                                      : 0
                                  : controller.currentIndex.value == 1
                                      ? snapshot.hasData != false
                                          ? controller.waitingList.value
                                          : 0
                                      : snapshot.hasData != false
                                          ? controller.connectedList.value
                                          : 0,
                              itemBuilder: (context, index) {
                                dynamic data = snapshot.data;
                                return controller.currentIndex.value == 0
                                    ? snapshot.hasData == false ||
                                            snapshot.connectionState !=
                                                ConnectionState.done
                                        ? Center(
                                            child: Text(
                                            " ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                        : activeConnectionCard(
                                            data: data[index],
                                            prefs: controller.prefs)
                                    : controller.currentIndex.value == 1
                                        ?
                                        // controller.waitingList.value == 0 ||
                                        snapshot.hasData == false ||
                                                snapshot.connectionState !=
                                                    ConnectionState.done
                                            ? Center(child: Text(" "))
                                            : waitingConnectionCard(
                                                data: data[index],
                                                prefs: controller.prefs)
                                        :
                                        // controller.connectedList.value == 0 ||
                                        snapshot.hasData == false ||
                                                snapshot.connectionState !=
                                                    ConnectionState.done
                                            ? Center(child: Text(" "))
                                            : whoIConnectedCard(
                                                data: data[index],
                                                prefs: controller.prefs);
                              }));
                    }),
                SizedBox(
                  height: Get.height * 0.1,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
