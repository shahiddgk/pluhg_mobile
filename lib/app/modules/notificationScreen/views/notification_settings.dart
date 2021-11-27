import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/notificationScreen/controllers/notifcation_settings.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingsView extends GetView<NotificationSettingsController> {
  final controller = Get.put(NotificationSettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: controller.getData1(),
          builder: (context, snapshot) {
            return Obx(() => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 34),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Color(0xFF080F18)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(height: controller.size.height * 0.02),
                      Text(
                        'Notifications Settings',
                        style: TextStyle(
                          color: pluhgColour,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: controller.size.height * 0.05),
                      _buildSwitchTile(
                        text: 'Push Notification',
                        icon: 'resources/svg/push.svg',
                        value: controller.push.value,
                        updateValue: (newValue) {
                          controller.push.value = newValue;
                          controller.notificationDetails["data"]
                              ["pushNotification"] = newValue;
                        },
                      ),
                      _buildSwitchTile(
                        text: 'Email Notification',
                        icon: 'resources/svg/email.svg',
                        value: controller.email.value,
                        updateValue: (newValue) {
                          controller.email.value = newValue;
                          controller.notificationDetails["data"]
                              ["emailNotification"] = newValue;
                        },
                      ),
                      _buildSwitchTile(
                        text: 'Text Notification',
                        icon: 'resources/svg/text.svg',
                        value: controller.text.value,
                        updateValue: (newValue) {
                          controller.text.value = newValue;
                          controller.notificationDetails["data"]
                              ["textNotification"] = newValue;
                        },
                      ),
                      SizedBox(height: controller.size.height * 0.35),
                      controller.isloading.value == true
                          ? Center(child: pluhgProgress())
                          : Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () async {
                                  controller.isloading.value = true;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  APICALLS apicalls = APICALLS();

                                  bool d =
                                      await apicalls.updateNotificationSettings(
                                          context: context,
                                          token: prefs
                                              .getString("token")
                                              .toString(),
                                         
                                          pushNotification: controller
                                                  .push.value,
                                          textNotification: controller
                                                  .text.value,
                                          emailNotification: controller.email.value
                                                  );
                                  if (d == false) {
                                    controller.isloading.value = false;
                                  }
                                },
                                child: Container(
                                  width: controller.size.width * 0.70,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: pluhgColour,
                                    borderRadius: BorderRadius.circular(22.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 14),
                    ],
                  ),
                ));
          }),
    );
  }

  Widget _buildSwitchTile({
    required String text,
    required String icon,
    required bool value,
    required Function updateValue,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 5, top: 14),
          child: Row(
            children: [
              SvgPicture.asset(icon),
              SizedBox(width: 12.5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF080F18),
                ),
              ),
              Expanded(child: Container()),
              FlutterSwitch(
                activeColor: Color(0xFFE2E2E2),
                inactiveColor: Color(0xFFE2E2E2),
                inactiveToggleColor: Color(0xFF898B8B),
                activeToggleColor: Color(0xFF18C424),
                width: 39.21,
                height: 20,
                // valueFontSize: 25.0,
                toggleSize: 19.5,
                value: value,
                borderRadius: 17.25,
                padding: 0.0,
                // showOnOff: true,
                onToggle: (val) {
                  updateValue(val);
                },
              ),
            ],
          ),
        ),
        Divider(color: Color(0x25080F18), thickness: 1.5),
      ],
    );
  }
}
