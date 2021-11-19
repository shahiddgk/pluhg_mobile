import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pluhg/core/values/assets.dart';
import 'package:pluhg/core/values/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: const Center(
        child: Text('Home'),
      ),
      bottomNavigationBar: Container(
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
            )),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.activeLabelColour,
            unselectedItemColor: Colors.black,
            unselectedLabelStyle: TextStyle(fontSize: 12.sp, height: 1.17),
            selectedLabelStyle: TextStyle(fontSize: 12.sp, height: 1.17),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAsset.INACTIVE_HOME_CONNECTIONS),
                activeIcon: SvgPicture.asset(AppAsset.ACTIVE_HOME_CONNECTIONS),
                label: 'Connections',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAsset.INACTIVE_HOME_CONNECT_PEOPLE),
                activeIcon:
                    SvgPicture.asset(AppAsset.ACTIVE_HOME_CONNECT_PEOPLE),
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
      ),
    );
  }
}
