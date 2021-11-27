import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/widgets/button.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.grey,
            ),
          ),
          actions: [
            Icon(Icons.notifications_outlined, color: Color(0xff080F18)),
          ],
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
                      height: 168.22.h,
                      width: 88.66.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40,
                                color: Color.fromARGB(5, 0, 0, 0))
                          ],
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
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
                      height: 168.22.h,
                      width: 88.66.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40,
                                color: Color.fromARGB(5, 0, 0, 0))
                          ],
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
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
                Container(
                  width: 339.w,
                  height: 47.65.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(39),
                      color: Color(0xffEBEBEB)),
                  child: Center(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Center(child: Text(controller.text.value)),
                      items: <String>[
                        'Both',
                        'Requester',
                        'Contact',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.text.value = val!;
                        if (val == "Both") {
                          // _message.text = contactMessage;
                          controller.defaultText.value =
                              controller.contactMessage.value;
                        }

                        if (val == "Requester") {
                          print(val);

                          // requesterMessage = _message.text;
                          // _message.text = requesterMessage;
                          controller.defaultText.value =
                              controller.requesterMessage.value;
                        }
                        if (val == "Contact") {
                          // contactMessage = _message.text;
                          // _message.text = contactMessage;
                          controller.defaultText.value =
                              controller.contactMessage.value;
                        }
                      },
                      underline: Container(),
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
}
