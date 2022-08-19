import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plug/app/values/colors.dart';

class OpenSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppColors.activeIconColour,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                '1. Open App Settings.\n\n2. Go to Permissions.\n\n3.Allow permission for the required service.\n\n4. Return to app & reload the page.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: RaisedButton(
                    color: AppColors.activeIconColour,
                    onPressed: () {
                      openAppSettings();
                    },
                    child: Text(
                      'Open App Settings',
                      style: TextStyle(color: Colors.white),
                    ))),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                    elevation: 0.5,
                    color: Colors.green,
                    textColor: AppColors.pluhgWhite,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Go Back',
                      style: TextStyle(color: AppColors.activeIconColour),
                    ))),
          ],
        )));
  }
}
