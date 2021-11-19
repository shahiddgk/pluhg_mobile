import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pluhg/core/values/assets.dart';
import 'package:pluhg/core/values/colors.dart';
import 'package:pluhg/features/connect_people/presentation/connect_people_screen.dart';
import 'package:pluhg/features/connections/presentation/connections_screen.dart';
import 'package:pluhg/features/messages/presentation/messages_screen.dart';
import 'package:pluhg/features/settings/presentation/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = const [
      ConnectionsScreen(),
      ConnectPeopleScreen(),
      MessagesScreen(),
      SettingsScreen()
    ];
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentTab,
        children: _screens,
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
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
          currentIndex: _currentTab,
          onTap: (int index) => setState(() {
            _currentTab = index;
          }),
          enableFeedback: false,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.activeLabelColour,
          unselectedItemColor: Colors.black,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.INACTIVE_HOME_CONNECTIONS),
              activeIcon: SvgPicture.asset(AppAsset.ACTIVE_HOME_CONNECTIONS),
              label: 'Connections',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.INACTIVE_HOME_CONNECT_PEOPLE),
              activeIcon: SvgPicture.asset(AppAsset.ACTIVE_HOME_CONNECT_PEOPLE),
              label: 'Connect People',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.INACTIVE_HOME_MESSAGES),
              activeIcon: SvgPicture.asset(AppAsset.ACTIVE_HOME_MESSAGES),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.INACTIVE_HOME_SETTINGS),
              activeIcon: SvgPicture.asset(AppAsset.ACTIVE_HOME_SETTINGS),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
