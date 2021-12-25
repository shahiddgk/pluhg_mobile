

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plug/app/values/colors.dart';

class ShowWidgets {

  static void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: AppColors.pluhgWhite.withOpacity(0.95),
        textColor: Colors.black);
  }

 static Widget fileSizeErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 60, color: Colors.red[300]),
            SizedBox(
              height: 15,
            ),
            Text(error,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.red[300])),
          ],
        ),
      ),
    );
  }
}