import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/connection_screen/widget/active_card.dart';
import 'package:plug/app/modules/connection_screen/widget/tab.dart';
import 'package:plug/app/modules/connection_screen/widget/waiting_card.dart';
import 'package:plug/app/modules/connection_screen/widget/who_i_connected.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/search_app_bar.dart';

import '../controllers/connection_screen_controller.dart';

class  ConnectionScreenView extends GetView<ConnectionScreenController> {
  final int connectionTabIndex;
  final controller = Get.put(ConnectionScreenController());
  final TextEditingController searchController = TextEditingController();

  ConnectionScreenView(this.connectionTabIndex){
   controller.currentIndex.value = connectionTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    //double width_item = (MediaQuery.of(context).size.width - 4.w) / 3;

    return Scaffold(
      appBar: SearchAppBar(searchController, (value) {}, messages_page: false),
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
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 12.0.w),
                  height: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(53),
                      color: Color(0xffEBEBEB)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.currentIndex.value = 0;
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 4.w) / 4,
                          child: connectionTab(
                            "Accepted",
                            controller.currentIndex.value == 0,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.currentIndex.value = 1;
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 4.w) / 4,
                          child: connectionTab(
                            "Waiting",
                            controller.currentIndex.value == 1,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.currentIndex.value = 2;
                        },
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width - 4.w) / 2.5,
                          child: connectionTab(
                            "Who I Connected",
                            controller.currentIndex.value == 2,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                FutureBuilder(
                  future: controller.currentIndex.value == 0
                      ? controller.activeData()
                      : controller.currentIndex.value == 1
                          ? controller.waitingData()
                          : controller.whoIconnectedData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          SizedBox(height: 40.h),
                          Center(child: pluhgProgress()),
                        ],
                      );
                    }
                    else if (snapshot.hasError) {
                      //print('project snapshot data is: ${projectSnap.data}');
                      return Column(
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Center(
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        ],
                      );
                    }

                    else if (snapshot.hasData) {

                      return Obx(() {
                        if(controller.currentIndex.value == 1 && controller.waitingList.value <= 0){
                          return Column (
                            children: [
                              SizedBox(
                                height: 40.h,
                              ),
                              Center(child: Text('No Connection data yet')),
                            ],
                          );
                        }
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.currentIndex.value == 0
                                  ? controller.activeList.value
                                  : controller.currentIndex.value == 1
                                      ? controller.waitingList.value
                                      : controller.connectedList.value,
                              itemBuilder: (context, index) {
                                dynamic data = snapshot.data;
                                return controller.currentIndex.value == 0
                                    ? snapshot.hasData == false ||
                                            snapshot.connectionState !=
                                                ConnectionState.done
                                        ? Center(
                                            child: Text(
                                              " ",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: activeConnectionCard(
                                              data: data[index],
                                              user: controller.user,
                                            ),
                                          )
                                    : controller.currentIndex.value == 1
                                        ?
                                        // controller.waitingList.value == 0 ||
                                        snapshot.hasData == false || snapshot.connectionState != ConnectionState.done || data.length <= 0
                                            ? Center(child: Text('No Connection data yet'))
                                            : Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: waitingConnectionCard(
                                                  data: data[index],
                                                  user: controller.user,
                                                  onRemoveCallBack: (){
                                                    //controller.waitingData();
                                                    controller.data['data'].removeAt(index);
                                                    controller.waitingList.value = controller.data['data'].length;
                                                  }
                                                ),
                                              )
                                        :
                                        // controller.connectedList.value == 0 ||
                                        snapshot.hasData == false || snapshot.connectionState != ConnectionState.done
                                            ? Center(child: Text(" "))
                                            : Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: whoIConnectedCard(
                                                  data: data[index],
                                                  user: controller.user,
                                                ),
                                              );
                              },
                            ),
                          );
                        }
                      );
                    }
                    else {
                      return Column (
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Center(child: Text('No Connection data yet')),
                        ],
                      );
                    }
                  },
                ),
                // SizedBox(
                //   height: Get.height * 0.1,
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}
