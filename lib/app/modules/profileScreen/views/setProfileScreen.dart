import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/connectionScreen/views/waiting_view.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/modules/profileScreen/controllers/set_profile.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/dialog_box.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetProfileScreenView extends GetView<SetProfileScreenController> {
  final String contact;
  final String userID;
  final String token;
  SetProfileScreenView(
      {required this.contact, required this.token, required this.userID});
  TextEditingController _nameController = TextEditingController();

  TextEditingController _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SetProfileScreenController());
  APICALLS apicalls = APICALLS();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.determinePosition(),
      builder: (context, snapshot) {
        return Obx(() => Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                      child: SvgPicture.asset("resources/svg/pluhg_logo2.svg")),
                  SizedBox(
                    height: 99,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      "Set Your Profile",
                      style: TextStyle(
                          color: pluhgColour,
                          fontSize: 28,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 338,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: _nameController,
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
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            ),
                          ),
                          !contact.contains("@")
                              ? Container(
                                  width: 338,
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Fill field";
                                      }
                                    },
                                    controller: _contactController,
                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      labelText: "Set your email",
                                      prefixIcon: Icon(Icons.email_outlined),
                                      labelStyle: TextStyle(
                                          color: Color(0xff707070),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Muli",
                                          fontStyle: FontStyle.normal,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                    ),
                                  ))
                              : Container(
                                  width: controller.size.width * 0.9,
                                  child: Row(children: [
                                    Container(
                                      width: 60,
                                      child: CountryCodePicker(
                                        boxDecoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff707070))),
                                        onInit: (val) {
                                          controller.currentCountryCode.value =
                                              val!.dialCode!;
                                          print(val.dialCode!);
                                          print("Victorhez");
                                        },
                                        initialSelection:
                                            controller.countryISOCode.value,
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
                                      width: 10,
                                    ),
                                    Container(
                                      width: controller.size.width * 0.7,
                                      child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().length == 0) {
                                              return "Field is required";
                                            }
                                            if (value.length < 6) {
                                              return "Add valid data";
                                            }
                                          },
                                          controller: _contactController,
                                          decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF080F18)),
                                            ),
                                            // border: UnderlineInputBorder(
                                            //   borderSide:
                                            //       BorderSide(color: Color(0xFF080F18)),
                                            // ),
                                            focusColor: Color(0xFF080F18),
                                            labelText: ' Enter Phone Number',
                                            labelStyle: TextStyle(
                                                color: Color(0xff707070),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Muli",
                                                fontStyle: FontStyle.normal,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          )),
                                    ),
                                  ]),
                                )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 76,
                  ),
                  controller.isLoading.value
                      ? Center(child: pluhgProgress())
                      : GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              controller.isLoading.value = true;
                              bool d = await apicalls.createProfile(
                                  userID: userID,
                                  token: token,
                                  contact: _contactController.text.contains("@")
                                      ? _contactController.text
                                      : controller.currentCountryCode.value +
                                          _contactController.text,
                                  contactType: !contact.contains("@")
                                      ? "phone"
                                      : "email",
                                  username: _nameController.text);

                              if (d == false) {
                                if (!_contactController.text.contains("@")) {
                                  prefs.setString("countryCode",
                                      controller.currentCountryCode.value);
                                }
                                controller.isLoading.value = false;
                              }
                            }
                          },
                          child: Center(
                            child: Container(
                              width: 261,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(59),
                                  color: pluhgColour),
                              child: Center(
                                child: Text(
                                  "Next",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )));
      },
    );
  }
}
