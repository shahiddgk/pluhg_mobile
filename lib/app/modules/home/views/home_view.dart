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
  final int index;
  // final dynamic data;
  HomeView({
    required this.index,
  });
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => controller.willPopCallback(),
        child: Obx(
          () => Scaffold(
            body: getBody(),
            bottomNavigationBar: _bottomNavigationBar(),
          ),
        ));
  }

  Widget _bottomNavigationBar() {
    return Container(
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
          currentIndex: controller.currentIndex.value,
          onTap: (int index) => controller.currentIndex.value = index,
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
              activeIcon: SvgPicture.asset('assets/svg/active_connections.svg'),
              label: 'Connections',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svg/inactive_connect_people.svg'),
              activeIcon: SvgPicture.asset('assets/svg/active_connect_people.svg'),
              label: 'Connect',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svg/inactive_messages.svg'),
              activeIcon: SvgPicture.asset('assets/svg/active_messages.svg'),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svg/inactive_settings.svg'),
              activeIcon: SvgPicture.asset('assets/svg/active_settings.svg'),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      ConnectionScreenView(),
      ConnectScreenView(),
      ChatScreenView(),
      ProfileScreenView()
    ];
    return IndexedStack(
      index: controller.currentIndex.value,
      children: pages,
    );
  }
}
