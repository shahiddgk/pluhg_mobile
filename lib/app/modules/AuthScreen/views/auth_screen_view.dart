import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/AuthScreen/views/otp_screen.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/auth_screen_controller.dart';

class AuthScreenView extends GetView<AuthScreenController> {
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final APICALLS apicalls = APICALLS();
  final controller = Get.put(AuthScreenController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.willPopCallback(),
      child: FutureBuilder(
          future: controller.determinePosition(),
          builder: (context, snapshot) {
            return Scaffold(
                body: SingleChildScrollView(
                    child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: controller.size.height * 0.11),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset("assets/svg/registrationblue.svg",
                        height: MediaQuery.of(context).size.height * 0.34),
                  ),
                  SizedBox(height: controller.size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, bottom: 0),
                    child: Text(
                      'Hi!',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                        color: pluhgColour,
                      ),
                    ),
                  ),

                  // SizedBox(hei)ght: size.height * 0.005),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 18, right: controller.size.width * 0.2, top: 0),
                    child: Text(
                      'Connect people without sharing their contact details.',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                    ),
                  ),
                  SizedBox(height: controller.size.height * 0.015),
                  Container(
                    // width: size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: Row(children: [
                        if (controller.isNumber.value)
                          Container(
                            width: 60,
                            child: CountryCodePicker(
                              // favorite: ['+1', 'US'],
                              onInit: (val) {
                                controller.currentCountryCode.value =
                                    val!.dialCode!;
                                print(val.dialCode!);
                                print("Victorhez");
                              },
                              initialSelection: controller.countryISOCode.value,
                              padding: EdgeInsets.zero,
                              showFlag: false,
                              onChanged: (val) {
                                controller.currentCountryCode.value =
                                    val.dialCode.toString().trim();
                                //   print("#" +
                                //       currentCountryCode +
                                //       "#");
                              },
                            ),
                          ),
                        SizedBox(
                          width: controller.size.width * 0.7,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length == 0) {
                                    return "Field is required";
                                  }
                                  if (value.length < 6) {
                                    return "Add valid data";
                                  }
                                },
                                controller: _textController,
                                onChanged: (val) {
                                  if (controller.isNumeric(val)) {
                                    controller.isNumber.value = true;
                                  } else {
                                    controller.isNumber.value = false;
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF080F18)),
                                  ),
                                  // border: UnderlineInputBorder(
                                  //   borderSide:
                                  //       BorderSide(color: Color(0xFF080F18)),
                                  // ),
                                  focusColor: Color(0xFF080F18),
                                  hintText: 'Phone Number or Email',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Color(0xFF080F18),
                                  ),
                                )),
                          ),
                        ),
                      ]),
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: Container(
                      width: 263.25.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            activeColor: pluhgColour,
                            checkColor: Colors.white,
                            value: controller.hasAccepted.value,
                            onChanged: (val) {
                              if (_textController.text.isNotEmpty) {
                                controller.hasAccepted.value = val!;
                              } else {
                                Get.snackbar("Sorry",
                                    "Please fill the email or phone box");
                              }
                            },
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'I agree to ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions ',
                                  style: TextStyle(
                                    color: pluhgColour,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        launchURL("https://pluhg.com/terms"),
                                ),
                                TextSpan(
                                  text: 'and\n',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: pluhgColour,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        launchURL("https://pluhg.com/privacy"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  controller.isLoading.value
                      ? Center(child: pluhgProgress())
                      : Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 261.w),
                          child: PluhgButton(
                              onPressed:
                                  controller.hasAccepted.value ? _submit : null,
                              text: controller.hasAccepted.value
                                  ? 'Continue'
                                  : 'Get Started',
                            ),
                        ),
                      ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )));
          }),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      var data;

      if (controller.hasAccepted.value) {
        controller.isLoading.value = true;

        if (controller.isNumeric(_textController.text)) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("countryCode", controller.currentCountryCode.value);
        }
        data = await apicalls.signUpSignIn(
            contact: _textController.text.contains("@")
                ? _textController.text
                : controller.currentCountryCode.value + _textController.text);
        if (data == false) {
          controller.isLoading.value = false;
        }
      }
    }
  }
}
