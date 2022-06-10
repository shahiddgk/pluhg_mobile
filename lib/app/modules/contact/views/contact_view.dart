import 'dart:typed_data';

import 'package:flutter/material.dart';
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
import 'package:plug/widgets/notif_icon.dart';

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
    return Obx(() {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 30,
            centerTitle: false,
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
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xffEBEBEB),
                borderRadius: BorderRadius.circular(39),
              ),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  controller.search.value = searchController.text;
                  print(searchController.text);
                },
                decoration: InputDecoration(
                  hintText: "Search contact",
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
                    ),
                  ),

                  // labelText: "Bill",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: pluhgMenuBlackColour,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            actions: [NotifIcon()],
          ),
          bottomSheet: Container(
            height: 70.h,
            child: Visibility(
              visible: controller.requesterContact.value.name.isNotEmpty &&
                      controller.contactContact.value.name.isNotEmpty
                  ? true
                  : false,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 261.w),
                  child: PluhgButton(
                    onPressed: () => goToMessageView(context),
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
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 15.35.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "${controller.title.value}",
                  style: TextStyle(
                    fontSize: 28,
                    color: pluhgColour,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 26,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _addContactItem(
                    pluhgContact: controller.requesterGroup.value,
                    contactData: controller.requesterContact.value,
                    type: 'Requester',
                    onTap: (pluhgContact, contactData) {
                      controller.unSelectRequester(pluhgContact, contactData);
                    },
                  ),
                  Expanded(
                    child: SvgPicture.asset("resources/svg/middle.svg"),
                  ),
                  _addContactItem(
                    pluhgContact: controller.contactGroup.value,
                    contactData: controller.contactContact.value,
                    type: 'Contact',
                    onTap: (pluhgContact, contactData) {
                      controller.unSelectContact(pluhgContact, contactData);
                    },
                  ),
                ],
              ),
              Expanded(
                  child: controller.permissionDenied.value &&
                          controller.contacts_.length != 0
                      ? Center(
                          child: Text("'Permission to read contacts denied'"),
                        )
                      : FutureBuilder(
                          future: controller.contactsFuture.future,
                          builder: (context, snapshot) {
                            final contacts = controller.contacts_;

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
                              return Column(
                                children: [
                                  SizedBox(height: 20.h),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: contacts.length,
                                      itemBuilder: (context, index) {
                                        PluhgContact pluhgContact =
                                            contacts[index];
                                        if (pluhgContact.contacts.isNotEmpty) {
                                          return contactItem(
                                              contact: pluhgContact,
                                              isRequestAndContactSelectionDone:
                                                  (controller
                                                          .requesterContact
                                                          .value
                                                          .name
                                                          .isNotEmpty &&
                                                      controller
                                                          .contactContact
                                                          .value
                                                          .name
                                                          .isNotEmpty),
                                              onTap: (tappedContact) {
                                                if (controller.requesterContact
                                                        .value.name.isEmpty ||
                                                    controller.contactContact
                                                        .value.name.isEmpty) {
                                                  if (controller
                                                      .requesterContact
                                                      .value
                                                      .name
                                                      .isEmpty) {
                                                    controller.selectRequester(
                                                        pluhgContact,
                                                        tappedContact);
                                                  } else if (controller
                                                          .contactContact
                                                          .value
                                                          .name
                                                          .isEmpty &&
                                                      controller
                                                          .requesterContact
                                                          .value
                                                          .name
                                                          .isNotEmpty) {
                                                    controller.selectContact(
                                                        pluhgContact,
                                                        tappedContact);
                                                  } else {
                                                    showPluhgDailog(
                                                        context,
                                                        "Info",
                                                        "So Sorry !  You can select the same person");
                                                  }
                                                } else if (controller
                                                        .contactContact
                                                        .value
                                                        .name
                                                        .isNotEmpty &&
                                                    controller
                                                        .requesterContact
                                                        .value
                                                        .name
                                                        .isNotEmpty) {
                                                  print('ON TAP CALLL ELSE IF');
                                                  showPluhgDailog(
                                                      context,
                                                      "Info",
                                                      "You can't have more than two contacts selected");
                                                }
                                              });
                                        } else {
                                          return SizedBox.shrink();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        )),
            ]),
          ));
    });
  }

//TOD
  goToMessageView(context) {
    Get.to(
      () => SendMessageView(
        contactContact: controller.contactContact.value.value,
        requesterContact: controller.requesterContact.value.value,
        contactImage: controller.contactContact.value.image,
        requesterImage: controller.requesterContact.value.image,
        contactName: controller.contactContact.value.name,
        requesterName: controller.requesterContact.value.name,
      ),
    );
  }

  Widget _addContactItem(
      {required PluhgContact pluhgContact,
      required ContactData contactData,
      required String type,
      required Function(PluhgContact pluhgContact, ContactData contactData)
          onTap}) {
    return Stack(
      //alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(top: 15, right: 20, left: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 40, color: Colors.black12)],
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            children: [
              contactImage(contactData.image, false),
              Text(
                contactData.name.isNotEmpty ? contactData.name : 'Add Contact',
                style: TextStyle(
                    color: Color(0xff121212),
                    letterSpacing: -0.3,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 4.0,
              ),
              contactData.value.isEmpty
                  ? Text("")
                  : Text(
                      contactData.value,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(
                            0xff898B8B,
                          ),
                          letterSpacing: -0.3,
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    ),
              SizedBox(
                height: 4.0,
              ),
              Container(
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: pluhgColour,
                ),
                child: Center(
                  child: Text(
                    type,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
        ),
        !contactData.isSelected
            ? Text("")
            : Positioned(
                top: 0.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () => onTap(pluhgContact, contactData),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.cancel,
                      color: Color(0xffF90D46),
                      size: 30,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget contactImage(Uint8List? image, bool isPluhgUser) {
    print("contact image ${isPluhgUser.toString()}");
    return Stack(
      children: [
        image == null
            ? Container(
                width: 70,
                height: 70,
                child: SvgPicture.asset("resources/svg/avatar.svg"))
            : Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(image),
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
        Visibility(
          visible: isPluhgUser,
          child: Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset("assets/svg/exists.svg"),
          ),
        )
      ],
    );
  }
}
