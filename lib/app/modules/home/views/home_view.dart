import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/chat_screen/controllers/chat_screen_controller.dart';
import 'package:plug/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:plug/app/modules/connection_screen/views/connect_two_people.dart';
import 'package:plug/app/modules/connection_screen/views/connection_screen_view.dart';
import 'package:plug/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/app/widgets/colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  // final String token, userID;
  final RxInt index;
  final int connectionTabIndex;

  // final dynamic data;
  HomeView({
    required this.index,
    this.connectionTabIndex = 0,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final controller_chat = Get.put(ChatScreenController());

  late List<Widget> pages;

  final controller = Get.put(HomeController());

  //Timer for retrieving dynamic in IOS
  Timer? _timerLink;

  @override
  void initState() {
    super.initState();
    pages = [
      ConnectionScreenView(widget.connectionTabIndex),
      ConnectScreenView(),
      ChatScreenView(),
      ProfileScreenView()
    ];
    WidgetsBinding.instance!.addObserver(this);
    // controller.goToDeepLink();
  }

  @override
  Widget build(BuildContext context) {
    print("[HomeView] build: ${widget.index.value}");
    return WillPopScope(
      onWillPop: () => controller.onWillPop(),
      child: Scaffold(
        body: Obx(() => pages[widget.index.value]),
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
              currentIndex: widget.index.value,
              onTap: (int index1) {
                widget.index.value = index1;
                // index = index1;
              },
              enableFeedback: false,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: pluhgColour,
              unselectedItemColor: Colors.black,
              selectedFontSize: 11.sp,
              unselectedFontSize: 11.sp,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: SvgPicture.asset(
                          'assets/svg/inactive_connections.svg')),
                  activeIcon:
                      SvgPicture.asset('assets/svg/active_connections.svg'),
                  label: 'Connections',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: SvgPicture.asset(
                          'assets/svg/inactive_connect_people.svg')),
                  activeIcon:
                      SvgPicture.asset('assets/svg/active_connect_people.svg'),
                  label: "Connect People",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset('assets/svg/inactive_messages.svg'),
                          //waiting for backend api changes
                          Positioned(
                            top: -10,
                            right: -6,
                            child:
                                controller_chat.total_unread_messages.value == 0
                                    ? Container()
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.pluhgColour,
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                              controller_chat
                                                  .total_unread_messages
                                                  .toString(),
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                          )
                        ],
                      )),
                  activeIcon:
                      SvgPicture.asset('assets/svg/active_messages.svg'),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child:
                          SvgPicture.asset('assets/svg/inactive_settings.svg')),
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

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    super.dispose();
  }
}
