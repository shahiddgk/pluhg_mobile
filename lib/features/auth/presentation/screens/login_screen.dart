import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluhg/core/values/colors.dart';
import 'package:pluhg/core/widgets/url.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.h,
          ),
          Center(child: SvgPicture.asset('assets/svgs/auth/login_banner.svg')),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 0),
            child: Text(
              'Hi!',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.pluhgColour,
              ),
            ),
          ),

          // SizedBox(hei)ght: size.height * 0.005),
          Padding(
            padding: EdgeInsets.only(left: 15.h, right: 15.w, top: 0),
            child: Text(
              'Connect people without sharing their contact details.',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.sp),
            ),
          ),
          SizedBox(height: 48.8.h),
          Container(
            // width: size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Row(children: [
                // if (controller.isNumber.value)
                Container(
                  width: 60,
                  child: CountryCodePicker(
                    // favorite: ['+1', 'US'],
                    onInit: (val) {
                      // controller.currentCountryCode.value = val!.dialCode!;
                      // print(val.dialCode!);
                    },
                    // initialSelection: controller.countryISOCode.value,
                    padding: EdgeInsets.zero,
                    showFlag: false,
                    onChanged: (val) {
                      // controller.currentCountryCode.value =
                      //     val.dialCode.toString().trim();
                      //   print("#" +
                      //       currentCountryCode +
                      //       "#");
                    },
                  ),
                ),
                SizedBox(
                  width: 50.w,
                  child: Form(
                    // key: _formKey,
                    child: TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().length == 0) {
                            return "Field is required";
                          }
                          if (value.length < 6) {
                            return "Add valid data";
                          }
                        },
                        // controller: _controller,
                        // onChanged: (val) {
                        //   if (controller.isNumeric(val)) {
                        //     controller.isNumber.value = true;
                        //   } else {
                        //     controller.isNumber.value = false;
                        //   }
                        // },
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF080F18)),
                          ),
                          // border: UnderlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Color(0xFF080F18)),
                          // ),
                          focusColor: Color(0xFF080F18),
                          hintText: 'Phone Number or Email',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp,
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
          Row(
            children: [
              Checkbox(
                activeColor: AppColors.pluhgColour,
                checkColor: Colors.white,
                // value: controller.hasAccepted.value,
                onChanged: (val) {
                  // if (_controller.text.isNotEmpty) {
                  //   controller.hasAccepted.value = val!;
                  // } else {
                  //   Get.snackbar(
                  //       "Sorry", "Please fill the email or phone box");
                  // }
                },
                value: null,
              ),
              Text(
                '  I agree to ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300),
              ),
              GestureDetector(
                onTap: () {
                  launchURL("https://pluhg.com/terms");
                },
                child: Text(
                  'Terms & Conditions ',
                  style: TextStyle(
                      color: AppColors.pluhgColour,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'and ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300),
              ),
              GestureDetector(
                onTap: () {
                  launchURL("https://pluhg.com/privacy");
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: AppColors.pluhgColour,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
