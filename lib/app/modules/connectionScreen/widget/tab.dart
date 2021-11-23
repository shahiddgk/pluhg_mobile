import 'package:flutter/material.dart';

Widget connectionTab(
  String text,
  bool active,
) {
  return Container(
    height: 31.88,
    width: 98.86,
    decoration: BoxDecoration(
        color: active == true ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(53)),
    child: Center(
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color:
                    active == true ? Color(0xff000BFF) : Color(0xff080F18)))),
  );
}
