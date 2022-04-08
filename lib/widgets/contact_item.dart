
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/widgets/radio_list_widget.dart';
import 'package:plug/widgets/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Widget contactItem(PluhgContact contact, Function()? onTap) {


  final List<ContactItemDataClass> temString = [];


  temString.addAll(contact.phoneNumbers.take(2).map((e) => ContactItemDataClass(value: e,type: contactItemType.phone)).toList());
  temString.addAll(contact.emailAddresses.take(2).map((e) => ContactItemDataClass(value: e,type: contactItemType.email)).toList());

  ContactItemDataClass? newRadioGroupValue = contact.selectedContact != null ? temString.firstWhere((element) => element.value == contact.selectedContact) : null;

  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _avatar(contact.name.substring(0, 1), contact.photo, contact.isPlughedUser),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                      ),
                    ),

                   /* if(contact.phoneNumbers.length <= 1 && contact.emailAddresses.length <=1)
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

                    if(contact.phoneNumbers.length > 1 || contact.emailAddresses.length > 1)*/

                    Column(
                      children: temString.map((e) => RadioListTitleComponent<ContactItemDataClass?>(
                        label: e.value,
                        value: e,
                        isChecked: contact.selectedContact == e.value,
                        itemSelected: (value){
                          print(value);

                          if(contact.selectedContact != null)
                            return;

                          newRadioGroupValue = value;
                          if(value?.type == contactItemType.phone){
                            contact.selectedContact =contact.phoneNumbers.firstWhere((element) => element == e.value);
                          }
                          else {
                            contact.selectedContact =contact.emailAddresses.firstWhere((element) => element == e.value);
                          }
                          onTap!();
                        },
                      )
                      ).toList(),
                    ),
                        /*Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: temString.map((e) => Container(
                            width: 220.w,
                            child: RadioListTile<ContactItemDataClass?>(
                              title: Text(e.value),
                              dense: true,
                              tileColor: Colors.red,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: 0,
                              ),
                              groupValue: newRadioGroupValue,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: e,
                              activeColor: AppColors.pluhgColour,
                              onChanged: (value) async{
                                print(value);
                                newRadioGroupValue = value;
                                if(value?.type == contactItemType.phone){
                                      contact.selectedContact =contact.phoneNumbers.firstWhere((element) => element == e.value);
                                    }
                                else {
                                      contact.selectedContact =contact.emailAddresses.firstWhere((element) => element == e.value);
                                    }
                                onTap!();
                              },),)).toList(),
                        ),*/
                  ],
                ),
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

enum contactItemType{
  email,
  phone,
}

class ContactItemDataClass{
  final String value;
  final contactItemType type;

  ContactItemDataClass({required this.value,required this.type});
}