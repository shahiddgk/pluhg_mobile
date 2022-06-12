import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:plug/app/data/http_manager.dart';
import 'package:plug/app/data/models/request/reminder_request_model.dart';
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

showPluhgDailog4(BuildContext context,String preText ,String connectionID, String party) {
  var reminderController = TextEditingController();
  reminderController.text = preText;
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
    ),
    elevation: 0,
    backgroundColor: Colors.white,
    child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add a Message",
            style: TextStyle(fontSize: 20, color: pluhgColour),
          ),
          Container(
            height: 320,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: pluhgColour,
              ),
            ),
            child: TextFormField(
              controller: reminderController,
              // onChanged: (value) {
              //   text = value;
              //   print(text);
              // },
              maxLines: 30,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  sendReminder(
                      context, reminderController.text, party, connectionID);
                },
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: pluhgColour,
                        )),
                    child: Center(
                      child: Text("Send Reminder",
                          style: TextStyle(fontSize: 12, color: pluhgColour)),
                    )),
              ),
              SizedBox(
                width: 12.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: pluhgColour,
                        )),
                    child: Center(
                      child: Text("Cancel",
                          style: TextStyle(fontSize: 12, color: pluhgColour)),
                    )),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

sendReminder(BuildContext context, String text, String party,
    String connectionID) async {
  if (text.length > 5) {
    HTTPManager()
        .sendReminder(ReminderRequestModel(
            message: text, connectionId: connectionID, party: party))
        .then((value) {
      Navigator.of(context).pop();
      pluhgSnackBar('Great', '$party has been notified');
    }).catchError((onError) {
      pluhgSnackBar('Sorry', onError.toString());
    });
    // final isSent = await APICALLS().sendReminderMessage(
    //   message: text,
    //   connectionID: connectionID,
    //   party: party,
    //   context: context,
    // );
    // if (isSent) {
    //   Navigator.of(context).pop();
    //   pluhgSnackBar('Great', '$party has been notified');
    // } else {
    //   pluhgSnackBar('Sorry', 'An unexpected error occurred. Please try again.');
    // }
  } else {
    pluhgSnackBar('Sorry', '$party must be up to five text');
  }
}

showPluhgRatingDialog(
  BuildContext context,
  String title,
  String subTitle, {
  required Function onCLosed,
}) {
  //initial value
  double rating = 0.0;
  print("rating $rating");
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
    ),
    elevation: 0,
    backgroundColor: Colors.white,
    child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, color: pluhgColour),
          ),
          Text(subTitle, style: TextStyle(fontSize: 12, color: Colors.black)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: pluhgColour,
              ),
              onRatingUpdate: (ratingValue) {
                print(rating);
                rating = ratingValue;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  onCLosed(rating);
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: pluhgColour,
                        )),
                    child: Center(
                      child: Text("OK",
                          style: TextStyle(fontSize: 12, color: pluhgColour)),
                    )),
              ),
              SizedBox(
                width: 12.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: pluhgColour,
                        )),
                    child: Center(
                      child: Text("Cancel",
                          style: TextStyle(fontSize: 12, color: pluhgColour)),
                    )),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
