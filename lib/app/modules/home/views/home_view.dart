import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/modules/ChatScreen/views/chat_screen_view.dart';
import 'package:plug/app/modules/connectionScreen/views/connect_two_people.dart';
import 'package:plug/app/modules/connectionScreen/views/connection_screen_view.dart';
import 'package:plug/app/modules/profileScreen/views/profile_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  // final String token, userID;
  final RxInt index;
  // final dynamic data;
  HomeView({
    required this.index,
  });
  List<Widget> pages = [
    ConnectionScreenView(),
    ConnectScreenView(),
    ChatScreenView(),
    ProfileScreenView()
  ];
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    if (index.value == null) {
      index.value = 0;
    }
    return WillPopScope(
      onWillPop: () => controller.willPopCallback(),
      child: Scaffold(
        body: Obx(() => pages[index.value]),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return Obx(() => Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 30,
                offset: const Offset(0, -4),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
            child: BottomNavigationBar(
              currentIndex: index.value,
              onTap: (int index1) {
                index.value = index1;
                // index = index1;
              },
              enableFeedback: false,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: pluhgColour,
              unselectedItemColor: Colors.black,
              selectedFontSize: 12.sp,
              unselectedFontSize: 12.sp,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/inactive_connections.svg'),
                  activeIcon:
                      SvgPicture.asset('assets/svg/active_connections.svg'),
                  label: 'Connections',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                      'assets/svg/inactive_connect_people.svg'),
                  activeIcon:
                      SvgPicture.asset('assets/svg/active_connect_people.svg'),
                  label: 'Connect',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/inactive_messages.svg'),
                  activeIcon:
                      SvgPicture.asset('assets/svg/active_messages.svg'),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/inactive_settings.svg'),
                  activeIcon:
                      SvgPicture.asset('assets/svg/active_settings.svg'),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ));
  }

  Widget getBody() {
    return IndexedStack(
      index: controller.currentIndex.value,
      children: pages,
    );
  }
}
