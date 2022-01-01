import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/app/widgets/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      child: Scaffold(
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: controller.size.height * 0.11),
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/svg/registrationblue.svg",
                    height: MediaQuery.of(context).size.height * 0.34,
                  ),
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
                    left: 18,
                    right: controller.size.width * 0.2,
                    top: 0,
                  ),
                  child: Text(
                    'Connect people without sharing their contact details.',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: controller.size.height * 0.015),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    children: [
                      //show if user entered a number i.e phoneNumber
                      if (controller.isNumber.value)
                        Container(
                          width: 60.w,
                          //library to fetch country codes
                          child: CountryCodePicker(
                            // favorite: ['+1', 'US'],
                            onInit: (val) async {
                              controller.currentCountryCode.value =
                              val!.dialCode!;
                              print(val.dialCode!);
                            },
                            backgroundColor: Colors.white,
                            initialSelection: controller.isoCountryCode.value,
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
                      Expanded(
                        //width: controller.size.width * 0.7,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
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
                                borderSide: BorderSide(
                                  color: Color(0xFF080F18),
                                ),
                              ),
                              focusColor: Color(0xFF080F18),
                              hintText: 'Phone Number or Email',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: Color(0xFF080F18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:4.0),
                      child: SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                              pluhgSnackBar(
                                  "Sorry", "Please add email or phone number");
                            }
                          },
                        ),
                      ),
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
                              ..onTap =
                                  () => launchURL("https://pluhg.com/terms"),
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
                              ..onTap =
                                  () => launchURL("https://pluhg.com/privacy"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
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
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (controller.hasAccepted.value) {
        controller.isLoading.value = true;
        if (controller.isNumeric(_textController.text)) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //save country code in preference
          prefs.setString("countryCode", controller.currentCountryCode.value);
        }

        final signedIn = await apicalls.signUpSignIn(
            contact: _textController.text.contains("@")
                ? _textController.text
                : controller.currentCountryCode.value + _textController.text);
        if (!signedIn) {
          controller.isLoading.value = false;
        }
      }
    }
  }
}
