import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'colors.dart';

Widget longButton(BuildContext context, String text) {
  Size size = MediaQuery.of(context).size;
  return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.075),
      width: size.width * 0.8,
      height: size.height * 0.07,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
                spreadRadius: 0)
          ],
          color: const Color(0xff000bff)),
      child: Center(
        child: Text(text,
            style: TextStyle(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w400,
                fontFamily: "Muli",
                fontStyle: FontStyle.normal,
                fontSize: size.height * 0.02),
            textAlign: TextAlign.center),
      ));
}

Widget newButton(String text) {
  return Container(
    height: 45,
    width: 261,
    decoration: BoxDecoration(
        color: pluhgColour, borderRadius: BorderRadius.circular(59)),
    child: Center(
      child: Text(text,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)),
    ),
  );
}

Widget button2(String text) {
  return Container(
    height: 28.46,
    width: 113.89,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(86),
      color: pluhgColour,
    ),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget button3(String text, Color color) {
  return Container(
    height: 45.h,
    width: 150.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(59),
      color: color,
    ),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget outline_button(String text,{onPressed}) {
  return InkWell(child: Container(
    height: 45.h,
    width: 150.w,
    decoration: BoxDecoration(
      border: Border.all(color: pluhgColour, width: 1),
      borderRadius: BorderRadius.circular(59),
      color: Colors.white,
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/message.svg"),
          Container(width: 12.w),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: pluhgColour,
            ),
          )
        ],
      ),
    ),
  ),onTap: (){
    onPressed();
  });
}

Widget button4(Widget widget, String text, Color color) {
  return Container(
    alignment: Alignment.center,
    height: 45,
    width: 159.53,
    decoration: BoxDecoration(
      border: Border.all(color: color, width: 2),
      borderRadius: BorderRadius.circular(59),
      color: Colors.transparent,
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget,
          SizedBox(
            width: 8,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}
