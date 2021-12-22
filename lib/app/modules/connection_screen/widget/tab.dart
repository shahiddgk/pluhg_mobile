import 'package:flutter/material.dart';

//connection tab widget
Widget connectionTab(
  String text,
  bool active,
) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
        color: active == true ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(25)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
