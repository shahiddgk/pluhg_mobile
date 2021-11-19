import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluhg/core/values/colors.dart';
import 'package:pluhg/core/widgets/pluhg_button.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({Key? key}) : super(key: key);

  @override
  _SetProfileScreenState createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Center(child: SvgPicture.asset("assets/svgs/auth/set_profile.svg")),
            SizedBox(
              height: 99.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 18.w),
              child: Text(
                "Set Your Profile",
                style: TextStyle(
                    color: AppColors.pluhgColour,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 18.w),
              child: Form(
                // key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 338.w,
                        child: TextFormField(
                          // controller: _nameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Fill field";
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Username (unique)",
                            labelStyle: TextStyle(
                                color: Color(0xff707070),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Muli",
                                fontStyle: FontStyle.normal,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          ),
                        ),
                      ),
                      // signUpWith == 'phone'
                      //     ?
                      Container(
                          width: 338,
                          child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Fill field";
                              }
                            },
                            // controller: _contactController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Set your email",
                              prefixIcon: Icon(Icons.email_outlined),
                              labelStyle: TextStyle(
                                  color: Color(0xff707070),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Muli",
                                  fontStyle: FontStyle.normal,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                          ))
                      // :
                      // SizedBox(
                      //     width: 53,
                      //     child: Row(children: [
                      //       Container(
                      //         width: 60,
                      //         child: CountryCodePicker(
                      //           boxDecoration: BoxDecoration(
                      //               border:
                      //                   Border.all(color: Color(0xff707070))),
                      //           onInit: (val) {
                      //             controller.currentCountryCode.value =
                      //                 val!.dialCode!;
                      //             print(val.dialCode!);
                      //             print("Victorhez");
                      //           },
                      //           initialSelection:
                      //               controller.countryISOCode.value,
                      //           padding: EdgeInsets.zero,
                      //           showFlag: false,
                      //           onChanged: (val) {
                      //             controller.currentCountryCode.value =
                      //                 val.dialCode.toString().trim();
                      //             //   print("#" +
                      //             //       currentCountryCode +
                      //             //       "#");
                      //           },
                      //         ),
                      //       ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // Container(
                      //   width: controller.size.width * 0.7,
                      //   child: TextFormField(
                      //       keyboardType: TextInputType.number,
                      //       validator: (value) {
                      //         if (value == null ||
                      //             value.trim().length == 0) {
                      //           return "Field is required";
                      //         }
                      //         if (value.length < 6) {
                      //           return "Add valid data";
                      //         }
                      //       },
                      //       controller: _contactController,
                      //       decoration: InputDecoration(
                      //         focusedBorder: UnderlineInputBorder(
                      //           borderSide:
                      //               BorderSide(color: Color(0xFF080F18)),
                      //         ),
                      //         // border: UnderlineInputBorder(
                      //         //   borderSide:
                      //         //       BorderSide(color: Color(0xFF080F18)),
                      //         // ),
                      //         focusColor: Color(0xFF080F18),
                      //         labelText: ' Enter Phone Number',
                      //         labelStyle: TextStyle(
                      //             color: Color(0xff707070),
                      //             fontWeight: FontWeight.w400,
                      //             fontFamily: "Muli",
                      //             fontStyle: FontStyle.normal,
                      //             fontSize:
                      //                 MediaQuery.of(context).size.height *
                      //                     0.02),
                      //       )),
                      // ),
                    ]),
              ),
            ),

            SizedBox(
              height: 76.h,
            ),
            // GestureDetector(
            //   onTap: () async {
            //     if (_formKey.currentState!.validate()) {
            //       controller.isLoading.value = true;
            //       var d = await apicalls.createProfile(
            //           userID: userID,
            //           token: token,
            //           contact: _contactController.text.contains("@")
            //               ? _contactController.text
            //               : controller.currentCountryCode.value +
            //                   _contactController.text,
            //           contactType: signUpWith == 'phone' ? "phone" : "email",
            //           username: _nameController.text);

            //       if (d["hasError"] == true) {
            //         controller.isLoading.value = true;
            //         showPluhgDailog(
            //             context, "So Sorry!!", "User Name has been taken");
            //       } else {
            //         controller.isLoading.value = true;
            //         SharedPreferences prefs =
            //             await SharedPreferences.getInstance();

            //         prefs.setString('token', token);
            //         prefs.setString('userName', _nameController.text);
            //         prefs.setBool("logged_out", false);
            //         prefs.setString('token', token.toString());
            //         prefs.setString(
            //             signUpWith == 'phone' ? "phoneNumber" : "emailAddress",
            //             _contactController.text);
            //         if (!_contactController.text.contains("@")) {
            //           prefs.setString(
            //               "countryCode", controller.currentCountryCode.value);
            //         }

            //         String? dynamicLinkID;
            //         if (prefs.getString('dynamicLink') != null) {
            //           dynamicLinkID = prefs.getString("dynamicLink");
            //         }
            //         if (prefs.getString('dynamicLink') != null) {
            //           var waitingConnections =
            //               await apicalls.getWaitingConnections(
            //                   token: token,
            //                   // userPhoneNumber: d["data"]
            //                   //     ["phoneNumber"],
            //                   contact: d["data"]["emailAddress"]);
            //           List waitingConns = waitingConnections['data'];
            //           dynamic data = waitingConns.singleWhere(
            //             (element) => element['_id'] == dynamicLinkID,
            //             orElse: () => null,
            //           );

            //           Get.offAll(() => WaitingView(
            //                 data: data,
            //               ));
            //         } else {
            //           Get.offAll(() => HomeView(
            //                 index: 1,
            //               ));
            //         }
            //       }
            //     }
            //   },
            //   child: Center(
            //     child: Container(
            //       width: 261,
            //       height: 45,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(59),
            //           color: pluhgColour),
            //       child: Center(
            //         child: Text(
            //           "Next",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Center(
              child: SizedBox(
                width: 261,
                child: PluhgButton(
                  text: "Next",
                  onPressed: () {},
                  fontSize: 15.sp,
                  borderRadius: 50,
                  verticalPadding: 12.5.h,
                ),
              ),
            ),

            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
