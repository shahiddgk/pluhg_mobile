import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/auth_screen/controllers/otp_screen_controller.dart';
import 'package:plug/app/widgets/app_bar.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                              text: "We've sent a one time verification code to ",
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
                            controller.startTimer();

                            controller.str.value = "OTP has been resent\n";

                            controller.start.value = 40;
                            controller.otp.value = "Sent Successfully";

                            await apicalls.signUpSignIn(contact: contact);
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
                                    onPressed: ()=>_submit(context),
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
    if (_otp.text.length == 4) {
      controller.loading.value = true;
      bool data = await apicalls.verifyOTP(
          context: context, contact: contact, code: _otp.text);
      if (data == false) {
        controller.loading.value = false;
      }
    } else {
      pluhgSnackBar('Sorry', 'Add your code');
    }
  }
}
