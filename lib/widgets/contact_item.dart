import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/widgets/radio_list_widget.dart';
import 'package:plug/widgets/text_style.dart';

Widget contactItem(
    {required PluhgContact contact,
    isRequestAndContactSelectionDone,
    Function(ContactData contact)? onTap}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _avatar(contact.name.substring(0, 1), contact.photo, false),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: contact.contacts.length,
                    itemBuilder: (ctx, i) {
                      return RadioListTitleComponent<ContactData?>(
                        label: contact.contacts[i].value,
                        value: contact.contacts[i],
                        isChecked: contact.contacts[i].isSelected,
                        itemSelected: (value) {
                          // if (isRequestAndContactSelectionDone) {
                          //   return;
                          // }
                          onTap!(value!);
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      Divider(),
    ],
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

// enum contactItemType {
//   email,
//   phone,
// }
//
// class ContactItemDataClass {
//   final String value;
//   final contactItemType type;
//
//   ContactItemDataClass({required this.value, required this.type});
// }
