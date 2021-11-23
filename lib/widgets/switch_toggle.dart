import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget switchTile({
  required BuildContext context,
  required IconData leading,
  required String title,
  required bool isOn,
  required Function(bool) onChanged,
}) {
  Size size = MediaQuery.of(context).size;
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        height: size.height * 0.07,
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 0)
            ],
            color: const Color(0xffe1e3ec)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(leading, color: Color(0xffa8a9ad)),
            Expanded(
              child: SwitchListTile(
                activeColor: Colors.white,
                activeTrackColor: Color(0xFF4bdc63),
                onChanged: onChanged,
                value: isOn,
                title: Text(
                  "$title",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Muli",
                      fontStyle: FontStyle.normal,
                      fontSize: MediaQuery.of(context).size.height * 0.02),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 2,
      )
    ],
  );
}
