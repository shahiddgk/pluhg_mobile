import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pluhg/core/values/colors.dart';
import 'package:pluhg/core/widgets/pluhg_button.dart';
import 'package:pluhg/core/widgets/status_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String len = "tryr";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(left: 20.0.w, right: 20.w, top: 43.h, bottom: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF263238)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 36.h),
            Text(
              'Verification',
              style: TextStyle(
                color: AppColors.pluhgColour,
                fontWeight: FontWeight.w600,
                fontSize: 28.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0.w),
              child: RichText(
                text: TextSpan(
                  text: "We've sent a one time verification code to ",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 15.sp,
                  ),
                  children: [
                    TextSpan(
                      text: 'contact',
                      //
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 49.h),
            Form(
              // key: _formKey,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 30.w),
                  child: PinCodeTextField(
                    hintCharacter: "-",
                    hintStyle: const TextStyle(color: Colors.black),
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
                      fieldHeight: 60.h,
                      fieldWidth: 60.w,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    // controller: _otp,
                    keyboardType: TextInputType.number,
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10.r,
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
            SizedBox(height: 46.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Did not get code?',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
              ),
            ),
            GestureDetector(
              onTap: () {
                // controller.startTimer();

                // controller.str.value = "OTP has been resent\n";

                // controller.start.value = 40;
                // controller.otp.value = "Sent Successfully";

                // apicalls.sendOTP(
                //   signUpWith: signUpWith,
                //   contact: contact,
                // );
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  " controller.otp.value",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.pluhgColour,
                  ),
                ),
              ),
            ),

            const Spacer(),
            Center(
              child: SizedBox(
                width: 261,
                child: PluhgButton(
                  text: 'Verify',
                  onPressed: len.length != 4
                      ? () {}
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => const StatusScreen(
                                      buttonText: "Continue",
                                      heading: "Successful",
                                      iconName: "success_status",
                                      // onPressed: (){},
                                      subheading:
                                          'Your Pone number as been successfuly verified, procced to login')));
                        },
                  fontSize: 15.sp,
                  borderRadius: 50,
                  verticalPadding: 12.5.h,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            // if (MediaQuery.of(context).viewInsets.bottom == 0) Spacer(),
            // Align(
            //   alignment: Alignment.center,
            //   child: len.length != 4
            //       ? Container()
            //       : InkWell(
            //           onTap: () async {
            //             // if (_formKey.currentState!.validate()) {
            //             //   controller.loading.value = true;

            //             //   var isVerified = await apicalls.verifyOTP(
            //             //       userid: userID,
            //             //       context: context,
            //             //       signUpWith: signUpWith.toString().trim(),
            //             //       contact: contact.toString().trim(),
            //             //       code: _otp.text);
            //             //   print(isVerified);

            //             //   if (isVerified != null) {
            //             //     controller.loading.value = false;

            //             //     var data = await apicalls.getProfile(
            //             //         token: isVerified, userID: userID);
            //             //     print("victorhezOtp");
            //             //     print(data);
            //             //     if (data['data']['userName'] == null) {
            //             //       print(data['data']['name']);
            //             //       print("object1111");
            //             //       Get.offAll(SetProfileScreenView(
            //             //         userID: userID,
            //             //         token: isVerified,
            //             //         signUpWith: signUpWith,
            //             //       ));
            //             //     } else {
            //             //       controller.loading.value = false;

            //             //       SharedPreferences prefs =
            //             //           await SharedPreferences.getInstance();
            //             //       prefs.setBool("logged_out", false);
            //             //       prefs.setString('token', isVerified.toString());
            //             //       //Getting dynamic link id
            //             //       String? dynamicLinkID;
            //             //       if (prefs.getString('dynamicLink') != null) {
            //             //         dynamicLinkID = prefs.getString("dynamicLink");
            //             //       }
            //             //       if (dynamicLinkID != null) {
            //             //         var userProfileDetails =
            //             //             await apicalls.getProfile(
            //             //                 token: prefs.get("token").toString(),
            //             //                 userID: prefs.get("userID").toString());
            //             //         var waitingConnections =
            //             //             await apicalls.getWaitingConnections(
            //             //                 token: isVerified,
            //             //                 // userPhoneNumber:
            //             //                 //     userProfileDetails[
            //             //                 //             "data"]
            //             //                 //         ["phoneNumber"],
            //             //                 contact: userProfileDetails["data"]
            //             //                     ["emailAddress"]);
            //             //         List waitingConns = waitingConnections['data'];
            //             //         dynamic data = waitingConns.singleWhere(
            //             //           (element) => element['_id'] == dynamicLinkID,
            //             //           orElse: () => null,
            //             //         );
            //             //         Get.offAll(() => WaitingView(
            //             //               data: data,
            //             //             ));
            //             //       } else {
            //             //         Get.offAll(() => HomeView(
            //             //               index: 1,
            //             //             ));
            //             //       }
            //             //     }
            //             //   } else {
            //             //     controller.loading.value = false;

            //             //     showPluhgDailog(context, "So sorry", "Wrong code");
            //             //   }
            //             // }
            //           },
            //           child: Container(
            //             width: controller.size.width * 0.70,
            //             height: 45,
            //             decoration: BoxDecoration(
            //               color: pluhgColour,
            //               borderRadius: BorderRadius.circular(22.5),
            //             ),
            //             child: Center(
            //               child: Text(
            //                 'Verify',
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 15,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ),
            // ),
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}
