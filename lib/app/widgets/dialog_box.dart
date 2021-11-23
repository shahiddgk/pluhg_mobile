import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/home/views/home_view.dart';

import 'colors.dart';

APICALLS apicalls = APICALLS();
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

showMessagePluhgDailog(BuildContext context, String type, String message) {
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
            Get.offAll(() => HomeView(index: 2));
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

showPluhgDailog4(BuildContext context, String contact) {
  {
    TextEditingController text = new TextEditingController();
    return showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          "Add a Message",
          style: TextStyle(fontSize: 20, color: pluhgColour),
        ),
        content: Container(
            padding: EdgeInsets.only(left: 5),
            height: 120,
            width: 200,
            decoration: BoxDecoration(border: Border.all(color: pluhgColour)),
            child: TextFormField(
              controller: text,
              maxLines: 4,
              decoration: InputDecoration(border: InputBorder.none),
            )),
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
                  child: Text("Send Reminder",
                      style: TextStyle(fontSize: 12, color: pluhgColour)),
                )),
            onPressed: () {
              Navigator.pop(context);
              if (text.text.length < 5) {
                apicalls.sendReminderMessage(
                    message: text.text,
                    contactContact: contact,
                    context: context);
              }
            },
          ),
        ],
      ),
    );
  }
}
