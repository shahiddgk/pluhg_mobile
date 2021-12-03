import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/app/modules/send_message/views/send_message_view.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/widgets/contact_item.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:plug/widgets/text_style.dart';

import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  final String who;
  final String token;
  final String userID;
  ContactView({required this.token, required this.userID, required this.who});
  final APICALLS apicalls = APICALLS();
  final controller = Get.put(ContactController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.grey,
              ),
            ),
            title: Container(
              width: double.infinity,
              height: 39.23,
              decoration: BoxDecoration(
                color: Color(0xffEBEBEB),
                borderRadius: BorderRadius.circular(39),
              ),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  controller.search.value = searchController.text;
                },
                decoration: InputDecoration(
                  hintText: "search contact..",
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: Color(0xff080F18),
                  ),
                  suffixIcon: Visibility(
                      visible: controller.search.value.isEmpty ? false : true,
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
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            actions: [
              Icon(Icons.notifications_outlined, color: Color(0xff080F18)),
            ],
          ),
          bottomSheet: Container(
            height: 70.h,
            child: Visibility(
                visible: controller.requesterName.value.isNotEmpty &&
                        controller.contactName.value.isNotEmpty
                    ? true
                    : false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 261.w),
                    child: PluhgButton(
                      onPressed: () async => onTap(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                            size: 15.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.35.h,
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
                  _addContactItem(
                    controller.requesterName.value,
                    controller.requesterContact.value,
                    controller.requesterImage,
                    'Requester',
                    () async {
                      final fullContact = await FlutterContacts.getContact(
                          controller.requesterId.value);

                      if (fullContact != null) {
                        controller.requesterImage = null;
                        controller.requesterName.value = "";
                        controller.requesterContact.value = "";
                        controller.contacts_
                            .add(PluhgContact.fromContact(fullContact));
                        controller.getContactList();
                      }
                    },
                  ),
                  Center(child: SvgPicture.asset("resources/svg/middle.svg")),
                  _addContactItem(
                    controller.contactName.value,
                    controller.contactContact.value,
                    controller.contactImage,
                    'Contact',
                    () async {
                      final fullContact = await FlutterContacts.getContact(
                          controller.contactId.value);

                      if (fullContact != null) {
                        controller.contactImage = null;
                        controller.contactContact.value = "";
                        controller.contactName.value = "";
                        controller.contacts_
                            .add(PluhgContact.fromContact(fullContact));
                        controller.getContactList();
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: Obx(
                  () {
                    if (controller.permissionDenied.value &&
                        controller.contacts_.length != 0) {
                      return Center(
                        child: Text("'Permission to read contacts denied'"),
                      );
                    }
                    return FutureBuilder(
                      future: controller.getContactList(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
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
                          );
                        } else {
                          return ListView.builder(
                              itemCount: controller.contacts_.length,
                              itemBuilder: (context, index) {
                                if (controller.contacts_[index].phoneNumber
                                        .isNotEmpty ||
                                    controller.contacts_[index].emailAddress
                                        .isNotEmpty) {
                                  if (controller.search.value.isNotEmpty &&
                                      controller.contacts_[index].name
                                          .toLowerCase()
                                          .contains(controller.search.value
                                              .toLowerCase())) {
                                    return contactItem(
                                      controller.contacts_[index],
                                      () async {
                                        if (controller
                                                .requesterName.value.isEmpty ||
                                            controller
                                                .contactName.value.isEmpty) {
                                          Contact? contact =
                                              await FlutterContacts.getContact(
                                                  controller
                                                      .contacts_[index].id!);

                                          if (contact != null) {
                                            PluhgContact pluhgContact =
                                                PluhgContact.fromContact(
                                                    contact);

                                            if (controller
                                                .requesterName.value.isEmpty) {
                                              controller.requesterId.value =
                                                  controller
                                                      .contacts_[index].id!;
                                              controller.requesterImage =
                                                  pluhgContact.photo;
                                              controller.requesterContact
                                                  .value = pluhgContact
                                                      .phoneNumber.isEmpty
                                                  ? pluhgContact.emailAddress
                                                  : pluhgContact.phoneNumber;
                                              controller.requesterName.value =
                                                  pluhgContact.name;
                                              controller.person.value =
                                                  "Select Contact";
                                              controller.contacts_
                                                  .remove(pluhgContact);

                                              if (controller
                                                  .contactName.value.isEmpty) {
                                                showPluhgDailog(context, "Info",
                                                    "Great!  You’ve selected the Requester, \nNow you will need to select a Contact");
                                              }
                                            } else if (controller.contactName
                                                    .value.isEmpty &&
                                                controller.requesterName.value
                                                    .isNotEmpty) {
                                              if (pluhgContact.phoneNumber !=
                                                  controller
                                                      .requesterContact.value) {
                                                controller.contactId.value =
                                                    controller
                                                        .contacts_[index].id!;
                                                controller.contactImage =
                                                    pluhgContact.photo;
                                                controller.contactContact
                                                    .value = pluhgContact
                                                        .phoneNumber.isEmpty
                                                    ? pluhgContact.emailAddress
                                                    : pluhgContact.phoneNumber;
                                                controller.contactName.value =
                                                    pluhgContact.name;
                                                controller.person.value =
                                                    "Click Next";
                                                controller.contacts_
                                                    .remove(pluhgContact);
                                              } else {
                                                showPluhgDailog(context, "Info",
                                                    "So Sorry !  You can select the same person");
                                              }
                                            }
                                          } else if (controller.contactName
                                                  .value.isNotEmpty &&
                                              controller.requesterName.value
                                                  .isNotEmpty) {
                                            showPluhgDailog(context, "Info",
                                                "You can't have more than two contacts selected");
                                          }
                                        }
                                      },
                                    );
                                  }
                                  return contactItem(
                                    controller.contacts_[index],
                                    () async {
                                      if (controller
                                              .requesterName.value.isEmpty ||
                                          controller
                                              .contactName.value.isEmpty) {
                                        Contact? contact =
                                            await FlutterContacts.getContact(
                                                controller
                                                    .contacts_[index].id!);

                                        if (contact != null) {
                                          PluhgContact pluhgContact =
                                              PluhgContact.fromContact(contact);

                                          if (controller
                                              .requesterName.value.isEmpty) {
                                            controller.requesterId.value =
                                                controller.contacts_[index].id!;
                                            controller.requesterImage =
                                                pluhgContact.photo;
                                            controller.requesterContact.value =
                                                pluhgContact.phoneNumber.isEmpty
                                                    ? pluhgContact.emailAddress
                                                    : pluhgContact.phoneNumber;
                                            controller.requesterName.value =
                                                pluhgContact.name;
                                            controller.person.value =
                                                "Select Contact";
                                            controller.contacts_
                                                .remove(pluhgContact);

                                            if (controller
                                                .contactName.value.isEmpty) {
                                              showPluhgDailog(context, "Info",
                                                  "Great!  You’ve selected the Requester, \nNow you will need to select a Contact");
                                            }
                                          } else if (controller
                                                  .contactName.value.isEmpty &&
                                              controller.requesterName.value
                                                  .isNotEmpty) {
                                            if (pluhgContact.phoneNumber !=
                                                controller
                                                    .requesterContact.value) {
                                              controller.contactId.value =
                                                  controller
                                                      .contacts_[index].id!;
                                              controller.contactImage =
                                                  pluhgContact.photo;
                                              controller.contactContact
                                                  .value = pluhgContact
                                                      .phoneNumber.isEmpty
                                                  ? pluhgContact.emailAddress
                                                  : pluhgContact.phoneNumber;
                                              controller.contactName.value =
                                                  pluhgContact.name;
                                              controller.person.value =
                                                  "Click Next";
                                              controller.contacts_
                                                  .remove(pluhgContact);
                                            } else {
                                              showPluhgDailog(context, "Info",
                                                  "So Sorry !  You can select the same person");
                                            }
                                          }
                                        } else if (controller
                                                .contactName.value.isNotEmpty &&
                                            controller.requesterName.value
                                                .isNotEmpty) {
                                          showPluhgDailog(context, "Info",
                                              "You can't have more than two contacts selected");
                                        }
                                      }
                                    },
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              });
                        }
                      },
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
//TOD
  Future onTap(context) async {
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

    String countryCode = controller.prefs!.getString("countryCode") ?? '';
    String phoneNumber = controller.prefs!.getString("phoneNumber") ?? '';
    String emailAddress = controller.prefs!.getString("emailAddress") ?? '';

    if (countryCode + finalcontact != phoneNumber &&
        countryCode + finalRequester != phoneNumber &&
        emailAddress != controller.requesterContact.value &&
        emailAddress != controller.contactContact.value &&
        finalRequester != phoneNumber &&
        finalcontact != phoneNumber) {
      if (controller.contactContact.value.contains("@")) {
        finalcontact = controller.contactContact.value;
      } else if (!controller.contactContact.value.contains("+")) {
        finalcontact = "$countryCode$finalcontact";
      }

      if (controller.requesterContact.value.contains("@")) {
        finalRequester = controller.requesterContact.value;
      } else if (!controller.requesterContact.value.contains("+")) {
        finalRequester = "$countryCode$finalRequester";
      }

      Get.to(
        () => SendMessageView(
          contactContact: finalcontact,
          requesterContact: finalRequester,
          contactImage: controller.contactImage,
          requesterImage: controller.requesterImage,
          contactName: controller.contactName.value,
          requesterName: controller.requesterName.value,
        ),
      );
    } else {
      showPluhgDailog(context, "So sorry", "You can not connect yourself");
    }
  }

  Widget _addContactItem(String requesterName, String requesterContact,
      Uint8List? requesterImage, String buttonText, Function onTap) {
    return Container(
      height: 188.22,
      width: 88.66,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 40, color: Color.fromARGB(5, 0, 0, 0))
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          requesterName.isEmpty
              ? Text("")
              : GestureDetector(
                  onTap: () => onTap(),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.cancel, color: Color(0xffF90D46))),
                ),
          requesterImage == null
              ? SvgPicture.asset("resources/svg/avatar.svg")
              : Container(
                  width: 67.37,
                  height: 69.35,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: MemoryImage(requesterImage)),
                      borderRadius: BorderRadius.circular(13)),
                ),
          Text(requesterName.isNotEmpty ? requesterName : 'Add Contact',
              style: TextStyle(
                  color: Color(0xff121212),
                  letterSpacing: -0.3,
                  fontSize: 10,
                  fontWeight: FontWeight.w400)),
          requesterContact.isEmpty
              ? Text("")
              : Text(requesterContact,
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
                  borderRadius: BorderRadius.circular(50), color: pluhgColour),
              child: Center(
                child: Text(buttonText,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400)),
              ))
        ],
      ),
    );
  }
}
