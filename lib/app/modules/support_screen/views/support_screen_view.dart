import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';

import '../controllers/support_screen_controller.dart';

class SupportScreenView extends GetView<SupportScreenController> {
  final String? email, token;
  SupportScreenView({this.token, this.email});

  final controller = Get.put(SupportScreenController());
  TextEditingController _subject = new TextEditingController();
  TextEditingController _body = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                SizedBox(height: controller.size.height * 0.05),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Color(0xFF080F18)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "resources/svg/help.svg",
                    height: MediaQuery.of(context).size.height * 0.34,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: controller.size.height * 0.006, bottom: controller.size.height * 0.009),
                  child: Text(
                    'How can we help you?',
                    style: TextStyle(
                      color: pluhgColour,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(39),
                    border: Border.all(
                      color: Color(0xFF898B8B),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(39),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        cursorColor: Color(0xFF080F18),
                        controller: _subject,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "It can't be empty";
                          }
                        },
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          hintText: 'Enter Subject',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: Color(0xFF080F18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: controller.size.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Color(0xFF898B8B),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        controller: _body,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "It can't be empty";
                          }
                        },
                        maxLines: 4,
                        cursorColor: Color(0xFF080F18),
                        decoration: InputDecoration(
                          hintMaxLines: 3,
                          focusColor: Colors.black,
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: Color(0xFF080F18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: controller.size.height * 0.050),
                controller.isLoading.value == true
                    ? Center(
                        child: pluhgProgress(),
                      )
                    : InkWell(
                        onTap: () {
                          if (_body.text.isNotEmpty && _subject.text.isNotEmpty) {
                            controller.isLoading.value = true;

                            APICALLS apicalls = APICALLS();
                            apicalls.sendSupportEmail(
                                emailAddress: email!,
                                subject: _subject.text,
                                token: token!,
                                emailContent: _body.text,
                                context: context);

                            Future.delayed(Duration(microseconds: 7000), () {
                              _subject.text = "";
                              _body.text = "";
                            });

                            controller.isLoading.value = false;
                          } else {
                            Get.snackbar("So sorry", "Can not send empty data");
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
                              'Send',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
