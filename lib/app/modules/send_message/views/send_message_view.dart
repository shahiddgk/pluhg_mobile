import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/app/widgets/button.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/widgets/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/send_message_controller.dart';

class SendMessageView extends GetView<SendMessageController> {
  final String contactContact, requesterContact, contactName, requesterName;
  final Uint8List? contactImage, requesterImage;
  final APICALLS apicalls = APICALLS();
  final controller = Get.put(SendMessageController());

  SendMessageView(
      {required this.contactName,
      required this.contactContact,
      required this.contactImage,
      required this.requesterContact,
      required this.requesterImage,
      required this.requesterName});

  final TextEditingController _bothMessage = TextEditingController();
  final TextEditingController _recieverMessage = TextEditingController();
  final TextEditingController _contactMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: SimpleAppBar(
          backButton: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Column(
              children: [
                Text(
                  "Would you like to add a message?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: pluhgColour,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88.66.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Column(
                        children: [
                          requesterName.isEmpty
                              ? Text("")
                              : requesterImage == null
                                  ? SvgPicture.asset("resources/svg/avatar.svg")
                                  : requesterImage == null
                                      ? SvgPicture.asset(
                                          "resources/svg/avatar.svg")
                                      : Container(
                                          width: 67.37.w,
                                          height: 69.35.h,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: MemoryImage(
                                                      requesterImage!)),
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                        ),
                          Text(
                              requesterName.isEmpty
                                  ? "Add Contact"
                                  : requesterName,
                              style: TextStyle(
                                  color: Color(0xff121212),
                                  letterSpacing: -0.3,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400)),
                          requesterContact.isEmpty
                              ? Text("")
                              : Text(requesterContact,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(0xff898B8B),
                                      letterSpacing: -0.3,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400)),
                          Container(
                              width: 74.62.w,
                              height: 20.86.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: pluhgColour),
                              child: Center(
                                child: Text("Requester",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ))
                        ],
                      ),
                    ),
                    SvgPicture.asset("resources/svg/middle.svg"),
                    Container(
                      width: 88.66.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Column(
                        children: [
                          contactName.isEmpty
                              ? Text("")
                              : contactImage == null
                                  ? SvgPicture.asset("resources/svg/avatar.svg")
                                  : contactImage == null
                                      ? SvgPicture.asset(
                                          "resources/svg/avatar.svg")
                                      : Container(
                                          width: 67.37.w,
                                          height: 69.35.h,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: MemoryImage(
                                                      contactImage!)),
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                        ),
                          Text(
                              contactName.isEmpty ? "Add Contact" : contactName,
                              style: TextStyle(
                                  color: Color(0xff121212),
                                  letterSpacing: -0.3,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400)),
                          contactContact.isEmpty
                              ? Text("")
                              : Text(contactContact,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(0xff898B8B),
                                      letterSpacing: -0.3,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400)),
                          Container(
                              width: 74.62.w,
                              height: 20.86.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: pluhgColour),
                              child: Center(
                                child: Text("Contact",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text("Send message to",
                    style: TextStyle(
                        color: Color(0xff263238),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 2.h,
                ),
                InkWell(
                  onTap: () {
                    contactMessageSelection(context);
                  },
                  child: Container(
                    width: 339.w,
                    height: 47.65.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(39),
                        color: Color(0xffEBEBEB)),
                    child: new Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              controller.text.value,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          height: 48,
                          width: 48,
                          child: Image.asset("assets/images/ic_dropdown.png"),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 26.83.h,
                ),
                Container(
                  height: 143.79.h,
                  width: 339.w,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: controller.text.value == "Both"
                          ? _bothMessage
                          : controller.text.value == "Contact"
                              ? _contactMessage
                              : _recieverMessage,
                      style: body2TextStyle,
                      maxLines: 300,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Type your message to ${controller.text.value} \n(Optional) ",
                        hintStyle: body2TextStyle,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff898B8B)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                ),
                SizedBox(
                  height: 20.h,
                ),
                controller.loading.value
                    ? Center(child: pluhgProgress())
                    : Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 261.w),
                          child: PluhgButton(
                            text: 'Connect Them',
                            onPressed: () async => onTap(context),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future onTap(context) async {
    controller.loading.value = true;
    var data = await apicalls.connectTwoPeople(
      requesterName: requesterName,
      contactName: contactName,
      requesterMessage: _recieverMessage.text,
      contactMessage: _contactMessage.text,
      bothMessage: _bothMessage.text,
      contactContact: contactContact,
      requesterContact: requesterContact,
      context: context,
    );
    if (data == false) {
      controller.loading.value = false;
    }
  }

  contactMessageSelection(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) {
          return Obx(
            () => Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 32.0,
                      ),
                      Text(
                        "Select Receiver",
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.pluhgColour),
                      ),
                      new Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: controller.selectedRadio.value,
                            activeColor: AppColors.pluhgColour,
                            onChanged: (value) {
                              controller.selectedRadioButton(value as int);
                            },
                          ),
                          Text(
                            "Both",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: controller.selectedRadio.value,
                            activeColor: AppColors.pluhgColour,
                            onChanged: (value) {
                              controller.selectedRadioButton(value as int);
                            },
                          ),
                          Text(
                            "Contact",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: [
                          Radio(
                            value: 3,
                            groupValue: controller.selectedRadio.value,
                            activeColor: AppColors.pluhgColour,
                            onChanged: (value) {
                              controller.selectedRadioButton(value as int);
                            },
                          ),
                          Text(
                            "Receiver",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: AppColors.pluhgColour,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
