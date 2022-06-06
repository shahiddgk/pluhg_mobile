import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/data/models/response/verify_otp_response_model.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/modules/notification_screen/views/notification_settings.dart';
import 'package:plug/app/modules/profile_screen/views/edit_profile.dart';
import 'package:plug/app/modules/support_screen/views/support_screen_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/screens/privacy_policy_screen.dart';
import 'package:plug/widgets/image.dart';
import '../../../services/UserState.dart';
import '../controllers/profile_screen_controller.dart';

class ProfileScreenView extends GetView<ProfileScreenController> {
  final controller = Get.put(ProfileScreenController());

  Future<bool> _logout() async {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Logout",
              style: TextStyle(color: pluhgColour),
            ),
            content: Text("Are you sure you want to logout?"),
            actions: [
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                    width: 47.67,
                    height: 31,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(59),
                        border: Border.all(
                          color: pluhgColour,
                        )),
                    child: Center(
                      child: Text("No",
                          style: TextStyle(fontSize: 12, color: pluhgColour)),
                    )),
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () async {
                  await UserState.logout();
                  print("[ProfileScreenView::_logout] user logged out");
                  Get.offAll(() => AuthScreenView());
                },
                child: Container(
                    width: 47.67,
                    height: 31,
                    decoration: BoxDecoration(
                      color: pluhgColour,
                      borderRadius: BorderRadius.circular(59),
                      // border: Border.all(
                      //   color: pluhgColour,
                      // )
                    ),
                    child: Center(
                      child: Text("Yes",
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    )),
              ),
            ],
          );
        });
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
        future: controller.fetchProfileDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            pluhgSnackBar('Sorry', snapshot.error.toString());
            return Center(
              child: Text('Error Occured'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: pluhgProgress(),
            );
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              height: controller.size.height * 0.42,
                              width: controller.size.width,
                              child: snapshot.data == null
                                  ? SvgPicture.asset(
                                      "resources/svg/profile.svg")
                                  //TODO uncomment

                                  : CachedNetworkImage(
                                      imageUrl: APICALLS.imageBaseUrl +
                                          (controller.profileDetails.value
                                                  .profileImage ??
                                              ""),
                                      height: controller.size.height * 0.42,
                                      width: controller.size.width,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),

                          ///OLD Code
                          /*Center(
                            child: Container(
                              height: controller.size.height * 0.42,
                              width: controller.size.width,
                              child: snapshot.data == null
                                  ? SvgPicture.asset("resources/svg/profile.svg")
                                  //TODO uncomment

                                  : Image.network(
                                      APICALLS.imageBaseUrl + snapshot.data['profileImage'].toString(),
                                      height: controller.size.height * 0.42,
                                      width: controller.size.width,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),*/

                          Container(
                            height: controller.size.height * 0.42,
                            width: controller.size.width,
                            color: Colors.black.withOpacity(0.65),
                          ),

                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 34),
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: Colors.transparent),
                                    onPressed: () {},
                                  ),
                                  SizedBox(
                                      height: controller.size.height * 0.02),
                                  Text(
                                    'My Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                      height: controller.size.height * 0.037),
                                  Row(
                                    children: [
                                      /*snapshot.data == null
                                          ? SvgPicture.asset("resources/svg/profile.svg")
                                          : CircleAvatar(
                                              backgroundColor: pluhgColour,
                                              backgroundImage: CachedNetworkImageProvider(APICALLS.imageBaseUrl + snapshot.data['profileImage']),
                                               radius: 40.19,
                                            ),*/

                                      snapshot.data == null
                                          ? SvgPicture.asset(
                                              "resources/svg/profile.svg")
                                          : cachedNetworkImageWidget(
                                              imageUrl: APICALLS.imageBaseUrl +
                                                  (snapshot
                                                          .data?.profileImage ??
                                                      ""),
                                              height: 80.19,
                                              width: 80.19,
                                            ),

                                      /// OLD Code
                                      /*snapshot.data == null
                                          ? SvgPicture.asset("resources/svg/profile.svg")
                                          : CircleAvatar(
                                              backgroundColor: pluhgColour,
                                              backgroundImage: NetworkImage(APICALLS.imageBaseUrl + snapshot.data['profileImage']),
                                              //TODO uncomment this part
                                              radius: 40.19,
                                            ),*/
                                      SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                              text: snapshot.data == null
                                                  ? "Set Name"
                                                  : (snapshot.data?.name ?? "")
                                                          .isEmpty
                                                      ? "Set Name"
                                                      : snapshot.data?.name ??
                                                          "",
                                              children: [
                                                TextSpan(
                                                  text: snapshot.data == null
                                                      ? "Loading ..."
                                                      : '\n@${snapshot.data?.userName ?? ""}',
                                                  style: TextStyle(
                                                    color: Color(0xFFD8B831),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              text: "Total Connections ",
                                              children: [
                                                TextSpan(
                                                  text: snapshot.data == null
                                                      ? ".."
                                                      : '${snapshot.data?.numberOfConnections ?? 0}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              text: "Plugh Score ",
                                              children: [
                                                TextSpan(
                                                  text: snapshot.data == null
                                                      ? ".."
                                                      : '${snapshot.data?.numberOfConnections ?? 0}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: controller.size.height * 0.04),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (controller.profileDetails != null) {
                                  User user = await UserState.get();
                                  Get.to(
                                    () => EditProfileView(
                                      name: controller
                                              .profileDetails.value.name ??
                                          "",
                                      username: controller
                                              .profileDetails.value.userName ??
                                          "",
                                      pics: controller.profileDetails.value
                                              .profileImage ??
                                          "",
                                      address: controller
                                              .profileDetails.value.address ??
                                          "",
                                      phone: controller.profileDetails.value
                                              .phoneNumber ??
                                          "",
                                      email: snapshot.data?.emailAddress ?? "",
                                      token: user.token,
                                      userID: user.id,
                                    ),
                                  );
                                }
                              },
                              child: Tile(
                                size: controller.size,
                                text: 'Edit Profile',
                                icon: 'resources/svg/user.svg',
                              ),
                            ),
                            SizedBox(height: controller.size.height * 0.02),
                            GestureDetector(
                              onTap: () =>
                                  Get.to(() => NotificationSettingsView()),
                              child: Tile(
                                size: controller.size,
                                text: 'Notifications Settings',
                                icon: 'resources/svg/notifications.svg',
                              ),
                            ),
                            SizedBox(height: controller.size.height * 0.02),
                            GestureDetector(
                              onTap: () async {
                                User user = await UserState.get();
                                Get.to(() => SupportScreenView(
                                      token: user.token,
                                      email: user.email,
                                    ));
                              },
                              child: Tile(
                                size: controller.size,
                                text: 'Support',
                                icon: 'resources/svg/support.svg',
                              ),
                            ),
                            SizedBox(height: controller.size.height * 0.02),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => PrivacyPolicyScreen());
                              },
                              child: Tile(
                                size: controller.size,
                                text: 'Privacy & Security',
                                icon: 'resources/svg/privacy.svg',
                              ),
                            ),
                            SizedBox(height: controller.size.height * 0.04),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    _logout();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: pluhgColour,
                                    radius: 22.5,
                                    child: SvgPicture.asset(
                                      'resources/svg/exit.svg',
                                      height: 16,
                                      width: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: pluhgColour,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
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

@override
Widget Tile({
  required Size size,
  required String icon,
  required String text,
}) {
  return Container(
    height: 47.65,
    width: size.width - 36,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(39),
      color: Color(0xFFEBEBEB),
    ),
    child: Row(
      children: [
        SizedBox(width: size.width * 0.08),
        SvgPicture.asset(
          icon,
          height: 20,
          width: 20,
          color: Color(0xFF080F18),
        ),
        SizedBox(width: size.width * 0.05),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Color(0xFF080F18),
          ),
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios, color: Color(0xFF080F18)),
        SizedBox(width: size.width * 0.08),
      ],
    ),
  );
}
