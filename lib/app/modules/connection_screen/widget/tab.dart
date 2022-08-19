import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//connection tab widget
Widget connectionTab(
  String text,
  bool active,
) {
  return Container(
    alignment: Alignment.center,
    height: 50.h,
    margin:  EdgeInsets.symmetric(vertical: 6.0.h),
    decoration: BoxDecoration(
        color: active == true ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(25)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10.0),
      child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  height: 1,
                  color:
                      active == true ? Color(0xff000BFF) : Color(0xff080F18)))),
    ),
  );
}
