import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/widgets/colours.dart';

showPluhgDailog(BuildContext context, String type, String message) {
  return showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        type,
        style: TextStyle(fontSize: 20, color: pluhgColour),
      ),
      content:
          Text(message, style: TextStyle(fontSize: 12, color: Colors.black)),
      actions: <Widget>[
        BasicDialogAction(
          title: Container(
              width: 47.67,
              height: 31,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(59),
                  border: Border.all(
                    color: pluhgColour,
                  )),
              child: Center(
                child: Text("OK",
                    style: TextStyle(fontSize: 12, color: pluhgColour)),
              )),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

showPluhgDailog3(
    BuildContext context, String type, String message, Function function) {
  return showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        type,
        style: TextStyle(fontSize: 20, color: pluhgColour),
      ),
      content:
          Text(message, style: TextStyle(fontSize: 12, color: Colors.black)),
      actions: <Widget>[
        BasicDialogAction(
          title: Container(
              width: 47.67,
              height: 31,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(59),
                  border: Border.all(
                    color: pluhgColour,
                  )),
              child: Center(
                child: Text("OK",
                    style: TextStyle(fontSize: 12, color: pluhgColour)),
              )),
          onPressed: () {
            Navigator.pop(context);
            function();
          },
        ),
      ],
    ),
  );
}

showPluhgDailog2(
  BuildContext context,
  String type,
  String message, {
  required Function onCLosed,
}) {
  return showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        type,
        style: TextStyle(fontSize: 20, color: pluhgColour),
      ),
      content:
          Text(message, style: TextStyle(fontSize: 12, color: Colors.black)),
      actions: <Widget>[
        BasicDialogAction(
          title: Container(
              width: 47.67,
              height: 31,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(59),
                  border: Border.all(
                    color: pluhgColour,
                  )),
              child: Center(
                child: Text("OK",
                    style: TextStyle(fontSize: 12, color: pluhgColour)),
              )),
          onPressed: () {
            Navigator.pop(context);
            onCLosed();
          },
        ),
      ],
    ),
  );
}

showPluhgDailog4(BuildContext context, String connectionID, String party) {
  var text = "";

  return showPlatformDialog(
    context: context,
    builder: (BuildContext context) => BasicDialogAlert(
      title: Text(
        "Add a Message",
        style: TextStyle(fontSize: 20, color: pluhgColour),
      ),
      content: Container(
        padding: EdgeInsets.only(left: 5),
        height: 120,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: pluhgColour,
          ),
        ),
        child: TextFormField(
          onChanged: (value) => text = value,
          maxLines: 4,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Container(
            width: 120.w,
            height: 51.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(59.r),
              border: Border.all(
                color: pluhgColour,
              ),
            ),
            child: Center(
              child: Text(
                "Send Reminder",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: pluhgColour,
                ),
              ),
            ),
          ),
          onPressed: () async {
            APICALLS apicalls = APICALLS();

            if (text.length > 5) {
              final isSent = await apicalls.sendReminderMessage(
                message: text,
                connectionID: connectionID,
                party: party,
                context: context,
              );
              if (isSent) {
                Navigator.of(context).pop();
                pluhgSnackBar('Great', '$party has been notified');
              } else {
                pluhgSnackBar('Sorry', 'An unexpected error occurred. Please try again.');
              }
            } else {
              pluhgSnackBar('Sorry', '$party must be up to five text');
            }
          },
        ),
      ],
    ),
  );
}
