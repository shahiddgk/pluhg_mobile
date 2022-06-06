import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/request/login_request_model.dart';
import 'package:plug/app/data/models/request/verify_otp_request_model.dart';
import 'package:plug/app/modules/auth_screen/controllers/otp_screen_controller.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/modules/profile_screen/views/set_profile_screen.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/app/widgets/app_bar.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/utils/validation_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreenView extends GetView<OTPScreenController> {
  final String contact;

  OTPScreenView({required this.contact});

  final controller = Get.put(OTPScreenController());
  final _formKey = GlobalKey<FormState>();
  TextEditingController _otp = new TextEditingController();
  APICALLS apicalls = APICALLS();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PluhgAppBar(),
        body: controller.loading.value
            ? Center(child: pluhgProgress())
            : Obx(
                () => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, top: 20, bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: controller.size.height * 0.03),
                        Text(
                          'Verification',
                          style: TextStyle(
                            color: pluhgColour,
                            fontWeight: FontWeight.w600,
                            fontSize: 28.sp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: controller.size.width * 0.24),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  "We've sent a one time verification code to ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  height: 1.6),
                              children: [
                                TextSpan(
                                  text: contact,
                                  //
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      height: 1.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 49.25.h),
                        Form(
                          key: _formKey,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0.h,
                                horizontal: 30.w,
                              ),
                              child: PinCodeTextField(
                                hintCharacter: "-",
                                hintStyle: TextStyle(color: Colors.black),
                                backgroundColor: Colors.transparent,
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 4,
                                obscureText: false,

                                animationType: AnimationType.fade,

                                pinTheme: PinTheme(
                                  inactiveColor: Colors.black,
                                  inactiveFillColor: Colors.white,
                                  shape: PinCodeFieldShape.circle,
                                  // borderRadius: BorderRadius.circular(50),
                                  fieldHeight: 60.w,
                                  fieldWidth: 60.w,
                                  activeFillColor: Colors.white,
                                ),
                                cursorColor: Colors.black,
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: _otp,
                                keyboardType: TextInputType.number,
                                boxShadows: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                // // onTap: () {
                                // //   print("Pressed");
                                // // },

                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                                onChanged: (String value) {},
                              )),
                        ),
                        SizedBox(height: 46.25.h),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Did not get code?',
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w300),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (controller.start.value == 0) {
                              controller.startTimer();
                              controller.str.value = "OTP has been resent\n";
                              controller.start.value = 30;
                              controller.otp.value = "Sent Successfully";
                              HTTPManager()
                                  .loginUser(LoginRequestModel(
                                      emailAddress:
                                          EmailValidator.validate(contact)
                                              ? contact
                                              : "",
                                      phoneNumber:
                                          PhoneValidator.validate(contact)
                                              ? contact
                                              : "",
                                      type: EmailValidator.validate(contact)
                                          ? User.EMAIL_CONTACT_TYPE
                                          : User.PHONE_CONTACT_TYPE))
                                  .then((value) {
                                controller.loading.value = false;
                                //Get.to(() => OTPScreenView(contact: contact));
                              }).catchError((onError) {
                                controller.loading.value = false;
                                pluhgSnackBar('Sorry', onError.toString());
                              });
                              //wait apicalls.signUpSignIn(contact: contact);
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              controller.otp.value,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: pluhgColour,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.44.h),
                        controller.loading.value
                            ? Center(
                                child: pluhgProgress(),
                              )
                            : Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 261.w),
                                  child: PluhgButton(
                                    onPressed: () => _submit(context),
                                    text: 'Verify',
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ));
  }

  void _submit(context) async {
    //If the user enter otp code
    if (_otp.text.length == 4) {
      controller.loading.value = true;
      HTTPManager()
          .verifyOtp(
        VerifyOtpRequestModel(
            emailAddress: EmailValidator.validate(contact) ? contact : "",
            phoneNumber: PhoneValidator.validate(contact) ? contact : "",
            type: EmailValidator.validate(contact)
                ? User.EMAIL_CONTACT_TYPE
                : User.PHONE_CONTACT_TYPE,
            code: _otp.text,
            deviceToken: controller.fcmToken),
      )
          .then((value) async {
        controller.loading.value = false;
        pluhgSnackBar('Great', 'Successfully logged in');

        SharedPreferences storage = await SharedPreferences.getInstance();
        storage.setBool(PREF_IS_FIRST_APP_RUN, false);

        if ((value.user?.isRegistered ?? false) &&
            (value.user?.data?.emailAddress?.isNotEmpty ?? false) &&
            (value.user?.data?.userName?.isNotEmpty ?? false)) {
          User user = await UserState.get();
          await UserState.store(
            User.registered(
              token: value?.token ?? "",
              id: value.user?.data?.sId ?? "",
              name: value.user?.data?.userName ?? "",
              phone: value.user?.data?.phoneNumber ?? "",
              email: value.user?.data?.emailAddress ?? "",
              regionCode: user.regionCode.isNotEmpty
                  ? user.regionCode
                  : User.DEFAULT_REGION_CODE,
              countryCode: user.countryCode.isNotEmpty
                  ? user.countryCode
                  : User.DEFAULT_COUNTRY_CODE,
            ),
          );

          Get.offAll(() => HomeView(index: 1.obs));
          return true;
        }

        Get.to(() => SetProfileScreenView(
              token: value?.token ?? "",
              userID: value.user?.data?.sId ?? "",
              contact: value.user?.data?.emailAddress?.isEmpty ?? false
                  ? value.user?.data?.phoneNumber ?? ""
                  : value.user?.data?.emailAddress ?? "",
            ));
      }).catchError((onError) {
        controller.loading.value = false;
        pluhgSnackBar('Sorry', onError.toString());
      });
      // bool data = await apicalls.verifyOTP(
      //     context: context,
      //     contact: contact,
      //     code: _otp.text,
      //     fcmToken: controller.fcmToken);
      // if (data == false) {
      //   controller.loading.value = false;
      // }
    } else {
      pluhgSnackBar('Sorry', 'Add your code');
    }
  }
}
