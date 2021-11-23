import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget profileTextField(
    BuildContext context, IconData leading, IconData trailing, Widget child) {
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
            Container(
              width: size.width * 0.5,
              child: child,
            ),
            Icon(trailing, color: Color(0xff000BFF).withAlpha(20))
          ],
        ),
      ),
      SizedBox(
        height: 2,
      )
    ],
  );
}
