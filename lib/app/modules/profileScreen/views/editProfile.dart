import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/profileScreen/controllers/edit_profile.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/dialog_box.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/widgets/progressBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileView extends GetView<EditProfileController> {
  final String token, userID, pics, username, email, name, phone, address;
  EditProfileView(
      {required this.token,
      required this.userID,
      required this.pics,
      required this.phone,
      required this.name,
      required this.email,
      required this.address,
      required this.username});
  final ImagePicker _picker = ImagePicker();
  TextEditingController _address = new TextEditingController();
  TextEditingController _username = new TextEditingController();

  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  final controller = Get.put(EditProfileController());
  APICALLS apicalls = APICALLS();
  Future<Object?>? getdata() async {
    controller.data2 = await apicalls.getProfile(token: token, userID: userID);

    _address = new TextEditingController(
        text: address.isEmpty || address == "null" ? "" : address);
    _username = new TextEditingController(text: username.toString());
    _email = new TextEditingController(text: email.toString());
    _phone = new TextEditingController(text: phone.toString());
    _name = new TextEditingController(
        text: name.isEmpty || name == "null" ? "" : name.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getdata(),
          builder: (context, data) {
            return SingleChildScrollView(
                child: Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 34),
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back_ios, color: Color(0xFF080F18)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: controller.size.height * 0.02),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: pluhgColour,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: controller.size.height * 0.027),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SafeArea(
                                      child: Container(
                                          child: new Wrap(children: <Widget>[
                                    new ListTile(
                                        leading: new Icon(
                                          Icons.photo_library,
                                          color: pluhgColour,
                                        ),
                                        title: new Text('Photo Library'),
                                        onTap: () async {
                                          controller.image.value =
                                              (await _picker.pickImage(
                                                  source:
                                                      ImageSource.gallery))!;
                                          Get.back();
                                          showPluhgDailog(context, "Info!",
                                              "Make sure you save");
                                        }),
                                    new ListTile(
                                      leading: new Icon(Icons.photo_camera,
                                          color: pluhgColour),
                                      title: new Text('Camera'),
                                      onTap: () async {
                                        controller.image.value =
                                            (await _picker.pickImage(
                                                source: ImageSource.camera))!;
                                        Get.back();
                                        showPluhgDailog(context, "Info!",
                                            "Make sure you save");
                                      },
                                    )
                                  ])));
                                });
                          },
                          child: Stack(
                            children: [
                              controller.image.value != null
                                  ? CircleAvatar(
                                      backgroundColor: pluhgColour,
                                      radius: controller.size.height * 0.05,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(
                                          File(controller.image.value!.path),
                                          fit: BoxFit.fill,
                                          width: 100,
                                          height: 100,
                                          // fit: BoxFit.fitHeight,
                                        ),
                                      ))
                                  : pics == "null"
                                      ? SvgPicture.asset(
                                          "resources/svg/profile.svg",
                                        )
                                      : CircleAvatar(
                                          backgroundColor: pluhgColour,
                                          backgroundImage: NetworkImage(
                                              "http://143.198.187.200:3001/uploads/${pics.toString()}"),
                                          radius: 40.19,
                                        ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () async {},
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 31.65 / 2,
                                    child: SvgPicture.asset(
                                      'resources/svg/camera.svg',
                                      height: 31.65,
                                      width: 31.65,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Color(0xFF080F18),
                                ),
                                text: name == "null"
                                    ? "Set Name"
                                    : name.toString(),
                                children: [
                                  TextSpan(
                                    text: '\n@$username',
                                    style: TextStyle(
                                      color: Color(0xFFD8B831),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: controller.size.height * 0.05),
                    InfoTile(
                      hintText: 'Your Full Name',
                      icon: 'resources/svg/user.svg',
                      controller: _name,
                    ),
                    InfoTile(
                      hintText: 'User Name',
                      icon: 'resources/svg/user.svg',
                      controller: _username,
                    ),
                    InfoTile(
                      hintText: 'Phone Number',
                      icon: 'resources/svg/phone.svg',
                      controller: _phone,
                    ),
                    InfoTile(
                      hintText: 'Enter Your Email',
                      icon: 'resources/svg/email.svg',
                      controller: _email,
                    ),
                    InfoTile(
                      hintText:
                          address == null || address == "" || address == "null"
                              ? "Enter Address"
                              : "",
                      icon: 'resources/svg/address.svg',
                      controller: _address,
                    ),

                    SizedBox(height: controller.size.height * 0.02),
                    // Spacer(),
                    controller.isloading.value
                        ? Center(child: pluhgProgress())
                        : Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // Navigator.of(context).push(
                                //     MaterialPageRoute(builder: (ctx) => SettingsScreen()));
                              },
                              child: InkWell(
                                onTap: () async {
                                  if (_username.text.toString().isNotEmpty ||
                                      _address.text.toString().isNotEmpty ||
                                      _email.text.toString().isNotEmpty ||
                                      _phone.text.toString().isNotEmpty ||
                                      _name.text.toString().isNotEmpty ||
                                      controller.image.value != null) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? token = prefs.getString("token");
                                    String? userID = prefs.getString("userID");

                                    if (controller.image.value != null) {
                                      controller.isloading.value = true;
                                      uploadNow(
                                        controller.image.value,
                                        token,
                                        name,
                                        controller.data2,
                                        userID,
                                      );

                                      getdata();
                                    } else if (_username.text
                                            .toString()
                                            .isNotEmpty ||
                                        _address.text.toString().isNotEmpty ||
                                        _email.text.toString().isNotEmpty ||
                                        _phone.text.toString().isNotEmpty ||
                                        _name.text.toString().isNotEmpty) {
                                      controller.isloading.value = true;
                                      bool res = await apicalls.setProfile2(
                                          context: context,
                                          token: token,
                                          userID: userID,
                                          userName: _username.text ==
                                                  controller.data2["data"]
                                                          ["userName"]
                                                      .toString()
                                              ? "nothing"
                                              : _username.text.isEmpty
                                                  ? "nothing"
                                                  : _username.text,
                                          name: _name.text.toString() ==
                                                  controller.data2["data"]
                                                          ["name"]
                                                      .toString()
                                              ? "nothing"
                                              : _name.text.isEmpty
                                                  ? "nothing"
                                                  : _name.text,
                                          address: _address.text ==
                                                  controller.data2["data"]
                                                          ["address"]
                                                      .toString()
                                              ? "nothing"
                                              : _address.text.isEmpty
                                                  ? "nothing"
                                                  : _address.text,
                                          phone: _phone.text ==
                                                  controller.data2["data"]
                                                          ["phoneNumber"]
                                                      .toString()
                                              ? "nothing"
                                              : _phone.text.isEmpty
                                                  ? "nothing"
                                                  : _phone.text,
                                          email: _email.text == email
                                              ? "nothing"
                                              : _email.text.isEmpty
                                                  ? "nothing"
                                                  : _email.text);
                                      if (res == false) {
                                        controller.isloading.value = false;
                                      }
                                      getdata();
                                    }
                                    print("object SGS");
                                    print(_name.text.toString());
                                    print(_username.text.toString());
                                  } else {
                                    Get.snackbar(
                                        "So Sorry", "You made no chnages");
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
                                      'Save Changes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 14),
                  ],
                ),
              ),
            ));
          }),
    );
  }

  uploadNow(
    XFile? image,
    String? token,
    String? name,
    var data,
    String? userID,
  ) async {
    if (image != null) {
      bool info = await apicalls.updateProfile(
        image,
        data: data,
        token: token!,
        userID: userID!,
        context: Get.context!,
      );
      if (info == false) {
        controller.isloading.value = false;
      }
    }
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  final String hintText;
  final String icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    double iconSize = 30;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Color(0xFF080F18),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(14),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF080F18), width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusColor: Color(0xFF080F18),
          labelText: hintText,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Color(0xFF080F18),
          ),
          prefixIconConstraints: BoxConstraints(
            minHeight: iconSize + 8,
            maxHeight: iconSize + 8,
            minWidth: iconSize + 8,
            maxWidth: iconSize + 8,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon,
              height: iconSize,
              width: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
