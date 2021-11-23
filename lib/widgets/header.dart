import 'package:flutter/material.dart';

import 'text_style.dart';

Widget header(String text, BuildContext context, bool primaryColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 20,
      ),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back_ios_outlined,
          color: primaryColor == true ? Color(0xff707070) : Color(0xff000BFF),
        ),
      ),
      Spacer(),
      Text(
        text,
        style: primaryColor == true ? headerTextStyle : header2TextStyle,
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
      )
    ],
  );
}
