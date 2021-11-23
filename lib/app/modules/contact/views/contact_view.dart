import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/send_message/views/send_message_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/dialog_box.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/widgets/contact_list.dart';
import 'package:plug/widgets/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  final String who;
  final String token;
  final String userID;
  ContactView({required this.token, required this.userID, required this.who});
  APICALLS apicalls = APICALLS();
  final controller = Get.put(ContactController());
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          bottomSheet: Container(
            height: 70,
            child: Visibility(
              visible: controller.requesterName.value.isNotEmpty &&
                      controller.contactName.value.isNotEmpty
                  ? true
                  : false,
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String finalRequester = controller.requesterContact.value
                      .trim()
                      .split(" ")
                      .join("")
                      .split("-")
                      .join("");
                  String finalcontact = controller.contactContact.value
                      .trim()
                      .split(" ")
                      .join("")
                      .split("-")
                      .join("");

                  print(prefs.getString("countryCode"));
                  print("ccc");
                  if (prefs.getString("countryCode").toString() +
                              finalcontact !=
                          prefs.getString("phoneNumber") &&
                      prefs.getString("countryCode").toString() +
                              finalRequester !=
                          prefs.getString("phoneNumber") &&
                      prefs.getString("emailAddress") !=
                          controller.requesterContact.value &&
                      prefs.getString("emailAddress") !=
                          controller.contactContact.value &&
                      controller.requesterContact.value
                              .trim()
                              .split(" ")
                              .join("")
                              .split("-")
                              .join("") !=
                          prefs.getString("phoneNumber") &&
                      controller.contactContact.value
                              .trim()
                              .split(" ")
                              .join("")
                              .split("-")
                              .join("") !=
                          prefs.getString("phoneNumber")) {
                    print("ggfgfgfgfg " + prefs.getString("phoneNumber")!);

                    print(prefs.getString("countryCode"));
                    Get.to(() => SendMessageView(
                          contactContact: controller.contactContact.value
                                  .contains("@")
                              ? controller.requesterContact.value
                              : !controller.contactContact.value.contains("+")
                                  ? "${prefs.getString("countryCode")}${controller.contactContact.value.trim().split(" ").join("").split("-").join("")}"
                                  : controller.contactContact.value
                                      .trim()
                                      .split(" ")
                                      .join("")
                                      .split("-")
                                      .join(""),
                          requesterContact: controller.requesterContact.value
                                  .contains("@")
                              ? controller.requesterContact.value
                              : !controller.requesterContact.value.contains("+")
                                  ? "${prefs.getString("countryCode")}${controller.requesterContact.value.trim().split(" ").join("").split("-").join("")}"
                                  : controller.requesterContact.value
                                      .trim()
                                      .split(" ")
                                      .join("")
                                      .split("-")
                                      .join(""),
                          contactImage: controller.contactImage,
                          requesterImage: controller.requesterImage,
                          contactName: controller.contactName.value,
                          requesterName: controller.requesterName.value,
                        ));
                  } else {
                    showPluhgDailog(
                        context, "So sorry", "You can not connect yourself");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 261,
                      decoration: BoxDecoration(
                          color: pluhgColour,
                          borderRadius: BorderRadius.circular(59)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Next",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: FutureBuilder(
              future: controller.getContactList(),
              builder: (context, snapshot) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 36,
                          ),
                          Container(
                              width: 235,
                              height: 39.23,
                              decoration: BoxDecoration(
                                color: Color(0xffEBEBEB),
                                borderRadius: BorderRadius.circular(39),
                              ),
                              child: TextFormField(
                                controller: searchController,
                                onChanged: (value) {
                                  controller.search.value =
                                      searchController.text;
                                },
                                decoration: InputDecoration(
                                    hintText: "search contact..",
                                    prefixIcon: Icon(
                                      Icons.search_outlined,
                                      color: Color(0xff080F18),
                                    ),
                                    suffixIcon: Visibility(
                                        visible: controller.search.value.isEmpty
                                            ? true
                                            : false,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            searchController.clear();
                                            controller.search.value = "";
                                          },
                                        )),

                                    // labelText: "Bill",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: pluhgMenuBlackColour,
                                        fontWeight: FontWeight.w300)),
                              )),
                          Spacer(),
                          Icon(Icons.notifications_outlined,
                              color: Color(0xff080F18)),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "${controller.person.value}",
                          style: TextStyle(
                              fontSize: 28,
                              color: pluhgColour,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 188.22,
                            width: 88.66,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 40,
                                      color: Color.fromARGB(5, 0, 0, 0))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                controller.requesterName.value.isEmpty
                                    ? Text("")
                                    : GestureDetector(
                                        onTap: () async {
                                          final fullContact =
                                              await FlutterContacts.getContact(
                                                  controller.requesterId.value);

                                          // _contactsSelected.remove(fullContact);
                                          controller.requesterImage = null;
                                          controller.requesterName.value = "";
                                          controller.requesterContact.value =
                                              "";
                                          controller.contacts_
                                              .add(fullContact!);
                                          controller.getContactList();
                                        },
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(Icons.cancel,
                                                color: Color(0xffF90D46))),
                                      ),
                                controller.requesterImage == null
                                    ? SvgPicture.asset(
                                        "resources/svg/avatar.svg")
                                    : controller.requesterImage == null
                                        ? SvgPicture.asset(
                                            "resources/svg/avatar.svg")
                                        : Container(
                                            width: 67.37,
                                            height: 69.35,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: MemoryImage(
                                                        controller
                                                            .requesterImage!)),
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                          ),
                                Text(
                                    controller.requesterName.value.isEmpty
                                        ? "Add Contact"
                                        : controller.requesterName.value,
                                    style: TextStyle(
                                        color: Color(0xff121212),
                                        letterSpacing: -0.3,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                                controller.requesterContact.value.isEmpty
                                    ? Text("")
                                    : Text(
                                        // _contactsSelected[0].emails.isEmpty
                                        //     ? _contactsSelected[0].phones.first.number
                                        //     : _contactsSelected[0].emails.first.address,
                                        controller.requesterContact.value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Color(0xff898B8B),
                                            letterSpacing: -0.3,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400)),
                                Container(
                                    width: 74.62,
                                    height: 20.86,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: pluhgColour),
                                    child: Center(
                                      child: Text("Requester",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                    ))
                              ],
                            ),
                          ),
                          Center(
                              child:
                                  SvgPicture.asset("resources/svg/middle.svg")),
                          Container(
                            height: 188.22,
                            width: 88.66,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 40,
                                      color: Color.fromARGB(5, 0, 0, 0))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                controller.contactName.value.isEmpty
                                    ? Text("")
                                    : GestureDetector(
                                        onTap: () async {
                                          final fullContact =
                                              await FlutterContacts.getContact(
                                                  controller.contactId.value);

                                          // _contactsSelected.remove(fullContact);
                                          controller.contactImage = null;
                                          controller.contactContact.value = "";
                                          controller.contactName.value = "";
                                          controller.contacts_
                                              .add(fullContact!);
                                          controller.getContactList();
                                        },
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(Icons.cancel,
                                                color: Color(0xffF90D46))),
                                      ),
                                controller.contactImage == null
                                    ? SvgPicture.asset(
                                        "resources/svg/avatar.svg")
                                    : controller.contactImage == null
                                        ? SvgPicture.asset(
                                            "resources/svg/avatar.svg")
                                        : Container(
                                            width: 67.37,
                                            height: 69.35,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: MemoryImage(
                                                        controller
                                                            .contactImage!)),
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                          ),
                                Text(
                                    controller.contactName.value.isEmpty
                                        ? "Add Contact"
                                        : controller.contactName.value,
                                    style: TextStyle(
                                        color: Color(0xff121212),
                                        letterSpacing: -0.3,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                                controller.contactContact.value.isEmpty
                                    ? Text("")
                                    : Text(controller.contactContact.value,
                                        // ? _contactsSelected[1].phones.first.number
                                        // : _contactsSelected[1].emails.first.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Color(0xff898B8B),
                                            letterSpacing: -0.3,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400)),
                                Container(
                                    width: 74.62,
                                    height: 20.86,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: pluhgColour),
                                    child: Center(
                                      child: Text("Contact",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => Expanded(
                            child:
                                controller.permissionDenied.value &&
                                        controller.contacts_.length != 0
                                    ? Center(
                                        child: Text(
                                            "'Permission to read contacts denied'"),
                                      )
                                    : controller.contacts_.isEmpty
                                        ? Center(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                pluhgProgress(),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Text(
                                                  'Please wait, fetching contacts takes 2 minutes or less to load',
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          )
                                        : controller.search.value.isEmpty
                                            ? ListView.builder(
                                                itemCount:
                                                    controller.contacts_.length,
                                                itemBuilder: (context, index) {
                                                  // print('425 ${_contacts[index].thumbnail}');
                                                  return Column(
                                                    children: [
                                                      if (controller
                                                          .contacts_[index]
                                                          .phones
                                                          .isNotEmpty)
                                                        contactList(
                                                            "${controller.contacts_[index].displayName}",
                                                            "${controller.contacts_[index].phones.isNotEmpty ? controller.contacts_[index].phones.first.number : '(none)'}",
                                                            controller
                                                                        .contacts_[
                                                                            index]
                                                                        .thumbnail !=
                                                                    null
                                                                ? Container(
                                                                    width: 70,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          radius:
                                                                              23,
                                                                          backgroundImage: MemoryImage(controller
                                                                              .contacts_[index]
                                                                              .thumbnail!),
                                                                        ),
                                                                        // Visibility(
                                                                        //   visible: _statusSelected[
                                                                        //               index] ==
                                                                        //           "Pluhg user"
                                                                        //       ? true
                                                                        //       : false,
                                                                        //   child: Positioned(
                                                                        //       top: 24.35,
                                                                        //       left: 30,
                                                                        //       child: SvgPicture
                                                                        //           .asset(
                                                                        //               "resources/svg/pluhg_user.svg")),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: 70,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        CircleAvatar(
                                                                            radius:
                                                                                23,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                controller.contacts_[index].displayName.substring(0, 1),
                                                                                style: contactTextStyleWhite,
                                                                              ),
                                                                            )),
                                                                        // Visibility(
                                                                        //   visible: _statusSelected[
                                                                        //               index] ==
                                                                        //           "Pluhg user"
                                                                        //       ? true
                                                                        //       : false,
                                                                        //   child: Positioned(
                                                                        //       top: 24.35,
                                                                        //       left: 30,
                                                                        //       child: SvgPicture
                                                                        //           .asset(
                                                                        //               "resources/svg/pluhg_user.svg")),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  ), () async {
                                                          if (controller
                                                                  .requesterName
                                                                  .value
                                                                  .isEmpty ||
                                                              controller
                                                                  .contactName
                                                                  .value
                                                                  .isEmpty) {
                                                            final fullContact =
                                                                await FlutterContacts
                                                                    .getContact(controller
                                                                        .contacts_[
                                                                            index]
                                                                        .id);

                                                            // _contactsSelected.add(fullContact!);
                                                            //removing data when it is selected

                                                            if (controller
                                                                .requesterName
                                                                .value
                                                                .isEmpty) {
                                                              controller
                                                                      .requesterId
                                                                      .value =
                                                                  controller
                                                                      .contacts_[
                                                                          index]
                                                                      .id;
                                                              controller
                                                                      .requesterImage =
                                                                  fullContact!
                                                                      .thumbnail;
                                                              controller
                                                                      .requesterContact
                                                                      .value =
                                                                  fullContact
                                                                      .phones
                                                                      .first
                                                                      .number;
                                                              controller
                                                                      .requesterName
                                                                      .value =
                                                                  fullContact
                                                                      .displayName;
                                                              controller.person
                                                                      .value =
                                                                  "Select Contact";
                                                              controller
                                                                  .contacts_
                                                                  .remove(
                                                                      fullContact);

                                                              showPluhgDailog(
                                                                  context,
                                                                  "Info",
                                                                  "Great!  You’ve selected the Requester, \nNow you will need to select a Contact");
                                                            } else if (controller
                                                                    .contactName
                                                                    .value
                                                                    .isEmpty &&
                                                                controller
                                                                    .requesterName
                                                                    .value
                                                                    .isNotEmpty) {
                                                              if (fullContact!
                                                                      .phones
                                                                      .first
                                                                      .number !=
                                                                  controller
                                                                      .requesterContact
                                                                      .value) {
                                                                controller
                                                                        .contactId
                                                                        .value =
                                                                    controller
                                                                        .contacts_[
                                                                            index]
                                                                        .id;
                                                                controller
                                                                        .contactImage =
                                                                    fullContact
                                                                        .thumbnail;
                                                                controller
                                                                        .contactContact
                                                                        .value =
                                                                    fullContact
                                                                        .phones
                                                                        .first
                                                                        .number;
                                                                controller
                                                                        .contactName
                                                                        .value =
                                                                    fullContact
                                                                        .displayName;
                                                                controller
                                                                        .person
                                                                        .value =
                                                                    "Click Next";
                                                                controller
                                                                    .contacts_
                                                                    .remove(
                                                                        fullContact);
                                                              } else {
                                                                showPluhgDailog(
                                                                    context,
                                                                    "Info",
                                                                    "So Sorry !  You can select the same person");
                                                              }
                                                            }

                                                            // print(_contacts[index]);
                                                          } else if (controller
                                                                  .contactName
                                                                  .value
                                                                  .isNotEmpty &&
                                                              controller
                                                                  .requesterName
                                                                  .value
                                                                  .isNotEmpty) {
                                                            showPluhgDailog(
                                                                context,
                                                                "Info",
                                                                "You can't have morethan two contacts selected");
                                                          }
                                                        }, "Not pluhg user")
                                                      else
                                                        Text(""),
                                                      controller
                                                              .contacts_[index]
                                                              .emails
                                                              .isNotEmpty
                                                          ? contactList(
                                                              "${controller.contacts_[index].displayName}",
                                                              "${controller.contacts_[index].emails.isNotEmpty ? controller.contacts_[index].emails.first.address : '(none)'}",
                                                              controller
                                                                          .contacts_[
                                                                              index]
                                                                          .thumbnail !=
                                                                      null
                                                                  ? Container(
                                                                      width: 70,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                23,
                                                                            backgroundImage:
                                                                                MemoryImage(controller.contacts_[index].thumbnail!),
                                                                          ),
                                                                          // Visibility(
                                                                          //   visible: _statusSelected[
                                                                          //               index] ==
                                                                          //           "Pluhg user"
                                                                          //       ? true
                                                                          //       : false,
                                                                          //   child: Positioned(
                                                                          //       top: 24.35,
                                                                          //       left: 30,
                                                                          //       child: SvgPicture
                                                                          //           .asset(
                                                                          //               "resources/svg/pluhg_user.svg")),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: 70,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          CircleAvatar(
                                                                              radius: 23,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  controller.contacts_[index].displayName.substring(0, 1),
                                                                                  style: contactTextStyleWhite,
                                                                                ),
                                                                              )),
                                                                          // Visibility(
                                                                          //   visible: _statusSelected[
                                                                          //               index] ==
                                                                          //           "Pluhg user"
                                                                          //       ? true
                                                                          //       : false,
                                                                          //   child: Positioned(
                                                                          //       top: 24.35,
                                                                          //       left: 30,
                                                                          //       child: SvgPicture
                                                                          //           .asset(
                                                                          //               "resources/svg/pluhg_user.svg")),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                              () async {
                                                              if (controller
                                                                      .requesterName
                                                                      .value
                                                                      .isEmpty ||
                                                                  controller
                                                                      .contactName
                                                                      .value
                                                                      .isEmpty) {
                                                                final fullContact =
                                                                    await FlutterContacts.getContact(controller
                                                                        .contacts_[
                                                                            index]
                                                                        .id);

                                                                // _contactsSelected.add(fullContact!);
                                                                //removing data when it is selected

                                                                if (controller
                                                                    .requesterName
                                                                    .value
                                                                    .isEmpty) {
                                                                  controller
                                                                          .requesterImage =
                                                                      fullContact!
                                                                          .thumbnail;
                                                                  controller
                                                                          .requesterId
                                                                          .value =
                                                                      controller
                                                                          .contacts_[
                                                                              index]
                                                                          .id;
                                                                  controller
                                                                          .requesterContact
                                                                          .value =
                                                                      fullContact
                                                                          .emails
                                                                          .first
                                                                          .address;
                                                                  controller
                                                                          .requesterName
                                                                          .value =
                                                                      fullContact
                                                                          .displayName;
                                                                  controller
                                                                          .person
                                                                          .value =
                                                                      "Select Contact";
                                                                  controller
                                                                      .contacts_
                                                                      .remove(
                                                                          fullContact);
                                                                  showPluhgDailog(
                                                                      context,
                                                                      "Info",
                                                                      "Great!  You’ve selected the Requester, \nNow you will need to select a Contact");
                                                                } else if (controller
                                                                        .contactName
                                                                        .value
                                                                        .isEmpty &&
                                                                    controller
                                                                        .requesterName
                                                                        .value
                                                                        .isNotEmpty) {
                                                                  if (fullContact!
                                                                          .emails
                                                                          .first
                                                                          .address !=
                                                                      controller
                                                                          .requesterContact
                                                                          .value) {
                                                                    controller
                                                                            .contactId
                                                                            .value =
                                                                        controller
                                                                            .contacts_[index]
                                                                            .id;
                                                                    controller
                                                                            .contactImage =
                                                                        fullContact
                                                                            .thumbnail;
                                                                    controller
                                                                            .contactContact
                                                                            .value =
                                                                        fullContact
                                                                            .emails
                                                                            .first
                                                                            .address;
                                                                    controller
                                                                            .contactName
                                                                            .value =
                                                                        fullContact
                                                                            .displayName;
                                                                    controller
                                                                            .person
                                                                            .value =
                                                                        "Click Next";
                                                                    controller
                                                                        .contacts_
                                                                        .remove(
                                                                            fullContact);
                                                                  } else {
                                                                    showPluhgDailog(
                                                                        context,
                                                                        "Info",
                                                                        "So Sorry !  You can select the same person");
                                                                  }
                                                                }

                                                                // print(_contacts[index]);
                                                              } else if (controller
                                                                      .contactName
                                                                      .value
                                                                      .isNotEmpty &&
                                                                  controller
                                                                      .requesterName
                                                                      .value
                                                                      .isNotEmpty) {
                                                                showPluhgDailog(
                                                                    context,
                                                                    "Info",
                                                                    "You can't have morethan two contacts selected");
                                                              }
                                                            }, "pluhg user")
                                                          : SizedBox(),
                                                    ],
                                                  );
                                                })
                                            : ListView.builder(
                                                itemCount:
                                                    controller.contacts_.length,
                                                itemBuilder: (context, index) {
                                                  // print('632 ${_contacts[index].thumbnail}');
                                                  if (controller
                                                      .contacts_[index]
                                                      .displayName
                                                      .toLowerCase()
                                                      .contains(controller
                                                          .search.value
                                                          .toLowerCase())) {
                                                    return Column(
                                                      children: [
                                                        if (controller
                                                            .contacts_[index]
                                                            .phones
                                                            .isNotEmpty)
                                                          contactList(
                                                              "${controller.contacts_[index].displayName}",
                                                              "${controller.contacts_[index].phones.isNotEmpty ? controller.contacts_[index].phones.first.number : '(none)'}",
                                                              controller
                                                                          .contacts_[
                                                                              index]
                                                                          .thumbnail !=
                                                                      null
                                                                  ? CircleAvatar(
                                                                      radius:
                                                                          23,
                                                                      backgroundImage: MemoryImage(controller
                                                                          .contacts_[
                                                                              index]
                                                                          .thumbnail!),
                                                                    )
                                                                  : CircleAvatar(
                                                                      radius:
                                                                          23,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          controller
                                                                              .contacts_[index]
                                                                              .displayName
                                                                              .substring(0, 1),
                                                                          style:
                                                                              contactTextStyleWhite,
                                                                        ),
                                                                      )),
                                                              () async {
                                                            if (controller
                                                                    .requesterName
                                                                    .value
                                                                    .isEmpty ||
                                                                controller
                                                                    .contactName
                                                                    .value
                                                                    .isEmpty) {
                                                              final fullContact =
                                                                  await FlutterContacts.getContact(
                                                                      controller
                                                                          .contacts_[
                                                                              index]
                                                                          .id);

                                                              // _contactsSelected.add(fullContact!);
                                                              //removing data when it is selected

                                                              if (controller
                                                                  .requesterName
                                                                  .value
                                                                  .isEmpty) {
                                                                controller
                                                                        .requesterImage =
                                                                    fullContact!
                                                                        .thumbnail;
                                                                controller
                                                                        .requesterContact
                                                                        .value =
                                                                    fullContact
                                                                        .phones
                                                                        .first
                                                                        .number;
                                                                controller
                                                                        .requesterName
                                                                        .value =
                                                                    fullContact
                                                                        .displayName;
                                                                controller
                                                                        .person
                                                                        .value =
                                                                    "Select Contact";
                                                                controller
                                                                    .contacts_
                                                                    .remove(
                                                                        fullContact);

                                                                showPluhgDailog(
                                                                    context,
                                                                    "Info",
                                                                    "Great!  You’ve selected the Requester, \nNow you will need to select a Contact");
                                                              } else if (controller
                                                                      .contactName
                                                                      .value
                                                                      .isEmpty &&
                                                                  controller
                                                                      .requesterName
                                                                      .value
                                                                      .isNotEmpty) {
                                                                if (fullContact!
                                                                        .phones
                                                                        .first
                                                                        .number !=
                                                                    controller
                                                                        .requesterContact
                                                                        .value) {
                                                                  controller
                                                                          .contactId
                                                                          .value =
                                                                      controller
                                                                          .contacts_[
                                                                              index]
                                                                          .id;
                                                                  controller
                                                                          .contactImage =
                                                                      fullContact
                                                                          .thumbnail;
                                                                  controller
                                                                          .contactContact
                                                                          .value =
                                                                      fullContact
                                                                          .phones
                                                                          .first
                                                                          .number;
                                                                  controller
                                                                          .contactName
                                                                          .value =
                                                                      fullContact
                                                                          .displayName;
                                                                  controller
                                                                          .person
                                                                          .value =
                                                                      "Click Next";
                                                                  controller
                                                                      .contacts_
                                                                      .remove(
                                                                          fullContact);
                                                                } else {
                                                                  showPluhgDailog(
                                                                      context,
                                                                      "Info",
                                                                      "So Sorry !  You can select the same person");
                                                                }
                                                              }

                                                              // print(_contacts[index]);
                                                            } else if (controller
                                                                    .contactName
                                                                    .value
                                                                    .isNotEmpty &&
                                                                controller
                                                                    .requesterName
                                                                    .value
                                                                    .isNotEmpty) {
                                                              showPluhgDailog(
                                                                  context,
                                                                  "Info",
                                                                  "You can't have morethan two contacts selected");
                                                            }
                                                          }, "not pluhg user")
                                                        else
                                                          Text(""),
                                                        controller
                                                                .contacts_[
                                                                    index]
                                                                .emails
                                                                .isNotEmpty
                                                            ? contactList(
                                                                "${controller.contacts_[index].displayName}",
                                                                "${controller.contacts_[index].emails.isNotEmpty ? controller.contacts_[index].emails.first.address : '(none)'}",
                                                                controller
                                                                            .contacts_[
                                                                                index]
                                                                            .thumbnail !=
                                                                        null
                                                                    ? CircleAvatar(
                                                                        radius:
                                                                            23,
                                                                        backgroundImage: MemoryImage(controller
                                                                            .contacts_[index]
                                                                            .thumbnail!),
                                                                      )
                                                                    : CircleAvatar(
                                                                        radius:
                                                                            23,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            controller.contacts_[index].displayName.substring(0,
                                                                                1),
                                                                            style:
                                                                                contactTextStyleWhite,
                                                                          ),
                                                                        )),
                                                                () async {
                                                                if (controller
                                                                        .requesterName
                                                                        .value
                                                                        .isEmpty ||
                                                                    controller
                                                                        .contactName
                                                                        .value
                                                                        .isEmpty) {
                                                                  final fullContact =
                                                                      await FlutterContacts.getContact(controller
                                                                          .contacts_[
                                                                              index]
                                                                          .id);

                                                                  // _contactsSelected.add(fullContact!);
                                                                  //removing data when it is selected

                                                                  if (controller
                                                                      .requesterName
                                                                      .value
                                                                      .isEmpty) {
                                                                    controller
                                                                            .requesterId
                                                                            .value =
                                                                        controller
                                                                            .contacts_[index]
                                                                            .id;
                                                                    controller
                                                                            .requesterImage =
                                                                        fullContact!
                                                                            .thumbnail;
                                                                    controller
                                                                            .requesterContact
                                                                            .value =
                                                                        fullContact
                                                                            .emails
                                                                            .first
                                                                            .address;
                                                                    controller
                                                                            .requesterName
                                                                            .value =
                                                                        fullContact
                                                                            .displayName;
                                                                    controller
                                                                            .person
                                                                            .value =
                                                                        "Select Contact";
                                                                    controller
                                                                        .contacts_
                                                                        .remove(
                                                                            fullContact);
                                                                    showPluhgDailog(
                                                                        context,
                                                                        "Info",
                                                                        "Great!  You’ve selected the Requester, \nNow you will need to select a Contact");
                                                                  } else if (controller
                                                                          .contactName
                                                                          .value
                                                                          .isEmpty &&
                                                                      controller
                                                                          .requesterName
                                                                          .value
                                                                          .isNotEmpty) {
                                                                    if (fullContact!
                                                                            .emails
                                                                            .first
                                                                            .address !=
                                                                        controller
                                                                            .requesterContact
                                                                            .value) {
                                                                      controller
                                                                              .contactId
                                                                              .value =
                                                                          controller
                                                                              .contacts_[index]
                                                                              .id;
                                                                      controller
                                                                              .contactImage =
                                                                          fullContact
                                                                              .thumbnail;
                                                                      controller.contactContact.value = fullContact
                                                                          .emails
                                                                          .first
                                                                          .address;
                                                                      controller
                                                                              .contactName
                                                                              .value =
                                                                          fullContact
                                                                              .displayName;
                                                                      controller
                                                                          .person
                                                                          .value = "Click Next";
                                                                      controller
                                                                          .contacts_
                                                                          .remove(
                                                                              fullContact);
                                                                    } else {
                                                                      showPluhgDailog(
                                                                          context,
                                                                          "Info",
                                                                          "So Sorry !  You can select the same person");
                                                                    }
                                                                  }

                                                                  // print(_contacts[index]);
                                                                } else if (controller
                                                                        .contactName
                                                                        .value
                                                                        .isNotEmpty &&
                                                                    controller
                                                                        .requesterName
                                                                        .value
                                                                        .isNotEmpty) {
                                                                  showPluhgDailog(
                                                                      context,
                                                                      "Info",
                                                                      "You can't have morethan two contacts selected");
                                                                }
                                                              }, "pluhg user")
                                                            : Text(""),
                                                      ],
                                                    );
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                })),
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
