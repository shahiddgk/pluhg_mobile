// import 'dart:typed_data';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/widgets/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget contactItem(PluhgContact contact, Function()? onTap) {
Widget contactItem(PluhgContact contact, Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _avatar(contact.name.substring(0, 1), contact.photo,
                  contact.isPlughedUser),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  contact.phoneNumbers.length <= 1
                      ? Text(
                          contact.phoneNumber.isEmpty
                              ? contact.emailAddress
                              : contact.phoneNumber,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      : Container(
                          child: Column(
                              children: contact.phoneNumbers
                                  .map((e) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                             Container(
                                                width: 220.w,
                                                child: RadioListTile(
                                                    title: Text(e),
                                                    value: contact.phoneNumbers
                                                        .indexOf(e),
                                                    groupValue: contact
                                                        .phoneNumbers
                                                        .indexOf(contact
                                                            .phoneNumber),
                                                    activeColor:
                                                        AppColors.pluhgColour,
                                                    onChanged: (value) async{

                                                      print(value);
                                                      contact.phoneNumber =
                                                          contact.phoneNumbers[
                                                              value as int];
                                                      onTap!();
                                                    }))
                                            /*RadioButton(
                                                description: e,
                                                value: false,
                                                groupValue: [],
                                                onChanged: (val) {})*/
                                          ]))
                                  .toList())),
                  Text(
                    (contact.emailAddress.isEmpty ||
                            contact.phoneNumber.isEmpty)
                        ? ""
                        : contact.emailAddress,
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.pluhgMenuGrayColour),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    ),
  );
}

Widget _avatar(String initials, Uint8List? photo, bool isPluhgUser) {
  return Container(
    width: 50.w,
    height: 50.h,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: Stack(
      children: [
        photo == null
            ? CircleAvatar(
                radius: 25.w,
                child: Center(
                  child: Text(
                    initials,
                    style: contactTextStyleWhite,
                  ),
                ),
              )
            : CircleAvatar(
                radius: 25.w,
                backgroundImage: MemoryImage(photo),
              ),
        Visibility(
          visible: isPluhgUser,
          child: Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset("assets/svg/exists.svg"),
          ),
        )
      ],
    ),
  );
}
