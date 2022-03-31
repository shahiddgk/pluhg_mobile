
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/widgets/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Widget contactItem(PluhgContact contact, Function()? onTap) {


  final List<String> temString = [];


  temString.addAll(contact.phoneNumbers.take(2).map((e) => e).toList());
  temString.addAll(contact.emailAddresses.take(2).map((e) => e).toList());


  ///int? radioGroupValue = contact.selectedContact != null ? temString.indexOf(contact.selectedContact!): 0;
  int? radioGroupValue = contact.selectedContact != null ? temString.indexOf(contact.selectedContact!): null;

  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _avatar(contact.name.substring(0, 1), contact.photo, contact.isPlughedUser),
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

                  if(contact.phoneNumbers.length <= 1 && contact.emailAddresses.length <=1)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.phoneNumber.isEmpty
                                ? contact.emailAddress
                                : contact.phoneNumber,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Text(
                            (contact.emailAddress.isEmpty || contact.phoneNumber.isEmpty)
                                ? ""
                                : contact.emailAddress,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.pluhgMenuGrayColour),
                          ),
                        ],
                      ),

                  if(contact.phoneNumbers.length > 1 || contact.emailAddresses.length > 1)
                      Column(
                        children: temString.map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 220.w,
                              child: RadioListTile(
                                title: Text(e),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                groupValue: radioGroupValue,
                                value: temString.indexOf(e),
                                activeColor: AppColors.pluhgColour,
                                onChanged: (value) async{
                                  print('NEW VALUE $value' );
                                  radioGroupValue = value as int;
                                  if(value == 0 || value == 1){
                                    contact.selectedContact = contact.phoneNumbers.firstWhere((element) => element == e);
                                  }else{
                                    contact.selectedContact = contact.emailAddresses.firstWhere((element) => element == e);
                                  }
                                  onTap!();
                                },),),
                          ],
                        )).toList(),
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
