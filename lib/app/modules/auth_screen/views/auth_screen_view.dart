import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/request/login_request_model.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/app/widgets/url.dart';
import 'package:plug/utils/validation_mixin.dart';

import '../../../services/UserState.dart';
import '../controllers/auth_screen_controller.dart';
import 'otp_screen.dart';

class AuthScreenView extends GetView<AuthScreenController> {
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // final APICALLS apicalls = APICALLS();
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
                    height: MediaQuery.of(context).size.height * 0.32,
                  ),
                ),
                SizedBox(height: controller.size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, bottom: 0),
                  child: Text(
                    'Hi!',
                    style: TextStyle(
                      fontSize: 46.sp,
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
                      fontSize: 15.sp,
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
                            backgroundColor: Colors.white,
                            initialSelection: controller.isoCountryCode.value,
                            padding: EdgeInsets.zero,
                            showFlag: false,
                            onInit: (val) async {
                              await controller.updateCountryCode(val);
                            },
                            onChanged: (val) async {
                              await controller.updateCountryCode(val);
                            },
                          ),
                        ),
                      Expanded(
                        //width: controller.size.width * 0.7,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            readOnly: controller.isLoading.value,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null) {
                                return "Field is required";
                              }

                              String error = _validateContact(value);
                              if (error.isNotEmpty) {
                                return error;
                              }
                            },
                            controller: _textController,
                            onChanged: (val) {
                              controller.isNumber.value =
                                  controller.isNumeric(val);
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
                                fontSize: 14.sp,
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
                      padding: const EdgeInsets.only(right: 4.0),
                      child: SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          activeColor: pluhgColour,
                          checkColor: Colors.white,
                          value: controller.hasAccepted.value,
                          onChanged: (val) {
                            String contact = _textController.text;
                            String error = _validateContact(contact);
                            if (error.isNotEmpty) {
                              controller.hasAccepted.value = false;
                              return pluhgSnackBar("Sorry", error);
                            }

                            controller.hasAccepted.value =
                                !controller.hasAccepted.value;
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
                SizedBox(height: 30.h),
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
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validateContact(String contact) {
    if (!contact.isNotEmpty) {
      return "Please add email or phone number";
    }

    if (contact.isNum) {
      String phone = _preparePhoneNumber(contact);
      return !PhoneValidator.validate(phone)
          ? "Please provide valid phone number"
          : '';
    }

    return !EmailValidator.validate(contact)
        ? "Please provide valid email"
        : '';
  }

  String _preparePhoneNumber(String phone) {
    return "${controller.currentCountryCode.value}${phone.replaceAll(new RegExp(r'^0+(?=.)'), '+')}";
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      print("[AuthScreenView:submit] invalid form");
      return;
    }

    if (!controller.hasAccepted.value) {
      print("[AuthScreenView:submit] agreements has not been accepted");
      return;
    }

    controller.isLoading.value = true;

    String contact = _textController.text;
    bool isPhoneContact = contact.isNum;
    if (isPhoneContact) {
      contact = this._preparePhoneNumber(contact);
    }

    print(
        "[AuthScreenView:submit] contact [$contact] is phone number [$isPhoneContact]");
    // if (isPhoneContact) {
    //   //@TODO something wrong here. Need to avoid this storing
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("countryCode", controller.currentCountryCode.value);
    // }

    HTTPManager()
        .loginUser(LoginRequestModel(
            emailAddress: EmailValidator.validate(contact) ? contact : "",
            phoneNumber: PhoneValidator.validate(contact) ? contact : "",
            type: EmailValidator.validate(contact)
                ? User.EMAIL_CONTACT_TYPE
                : User.PHONE_CONTACT_TYPE))
        .then((value) {
      controller.isLoading.value = false;
      Get.to(() => OTPScreenView(contact: contact));
    }).catchError((onError) {
      controller.isLoading.value = false;
      pluhgSnackBar('Sorry', onError.toString());
    });
    //await apicalls.signUpSignIn(contact: contact);
  }
}
