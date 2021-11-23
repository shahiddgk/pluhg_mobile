import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:plug/app/modules/AuthScreen/views/auth_screen_view.dart';
import 'package:plug/app/modules/AuthScreen/views/otp_screen.dart';
import 'package:plug/app/modules/connectionScreen/views/waiting_view.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/modules/profileScreen/views/setProfileScreen.dart';
import 'package:plug/app/widgets/dialog_box.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class APICALLS {
  static const url = "http://3.145.68.76";

  late Size screenSize;

  Future<bool> signUpSignIn({String? contact}) async {
    var uri = Uri.parse("$url/api/login");

    var body = {
      'emailAddress': contact!.contains("@") ? contact : '',
      'phoneNumber': !contact.contains("@") ? contact : '',
      'type': contact.contains("@") ? 'email' : 'phone'
    };

    //print("signUp encoded body ${jsonEncode(body)}");

    var response = await http.post(uri,
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});
    var parsedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      pluhgSnackBar('Great', parsedResponse['message'].toString());
      Get.to(OTPScreenView(contact: contact));
      return false;
    } else {
      pluhgSnackBar('Sorry', parsedResponse['message'].toString());
      return false;
    }
  }

  Future<bool> verifyOTP({
    required String contact,
    required BuildContext context,
    required String code,
  }) async {
    var uri = Uri.parse("$url/api/verifyOTP");
    bool success;
    var body = {
      "emailAddress": contact.contains("@") ? contact : "",
      "phoneNumber": !contact.contains("@") ? contact : "",
      "code": code,
      "type": contact.contains("@") ? "email" : 'phone'
    };

    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

    var parsedResponse = jsonDecode(response.body);

    print(parsedResponse);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      pluhgSnackBar('Great', 'Successfully logged in');
      // Get.to(OTPScreenView(contact: contact));

      // prefs.setString('userID', userid);
      if (parsedResponse['data']['user']['isRegistered'] == false) {
        Get.offAll(SetProfileScreenView(
          userID: parsedResponse['data']['user']['data']['_id'].toString(),
          token: parsedResponse['data']['token'].toString(),
          contact: parsedResponse['data']['user']['data']['emailAddress'] ==
                  null
              ? parsedResponse['data']['user']['data']['phoneNumber'].toString()
              : parsedResponse['data']['user']['data']['emailAddress']
                  .toString(),
        ));
      } else {
        prefs.setBool("logged_out", false);
        prefs.setString('token', parsedResponse['data']['token'].toString());
        prefs.setString(
            'userID', parsedResponse['data']['user']['data']['_id'].toString());
        print(parsedResponse['data']['user']['data']['_id'].toString());
        String? dynamicLinkID;
        if (prefs.getString('dynamicLink') != null) {
          dynamicLinkID = prefs.getString("dynamicLink");
        }
        if (dynamicLinkID != null) {
          var waitingConnections = await getWaitingConnections(
              token: parsedResponse['data']['token'].toString(),
              contact: parsedResponse['data']['user']['data']['emailAddress']
                  .toString());

          List waitingConns = waitingConnections['data'];
          dynamic data = waitingConns.singleWhere(
            (element) => element['_id'] == dynamicLinkID,
            orElse: () => null,
          );
          Get.offAll(() => WaitingView(
                data: data,
              ));
        }
        if (dynamicLinkID == null) {
          Get.offAll(() => HomeView(
                index: 1,
              ));
        }
      }
      return false;
    } else {
      pluhgSnackBar('Sorry', parsedResponse['message'].toString());
      return false;
    }
  }

  Future<bool> createProfile(
      {required String userID,
      required String token,
      required String contact,
      required String contactType,
      required String username}) async {
    var uri = Uri.parse("$url/api/createProfile/$userID");

    var body = {};

    if (contactType == "email") {
      body = {
        "phoneNumber": contact,
        "userName": username,
      };
    } else if (contactType == "phone") {
      body = {
        "emailAddress": contact,
        "userName": username,
      };
    }

    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(body));

    var parsedResponse = jsonDecode(response.body);
    print(parsedResponse);

    if (parsedResponse["hasError"] == false) {
      print(parsedResponse);
      pluhgSnackBar('Great', 'Your profile Has been set');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImage',
          parsedResponse["data"]["userData"]["profileImage"].toString());

      prefs.setString('token', token);
      prefs.setString('userName', username);
      prefs.setBool("logged_out", false);
      prefs.setString(
          !contact.contains("@") ? "phoneNumber" : "emailAddress", contact);

      String? dynamicLinkID;
      if (prefs.getString('dynamicLink') != null) {
        dynamicLinkID = prefs.getString("dynamicLink");
      }
      if (prefs.getString('dynamicLink') != null) {
        var waitingConnections = await apicalls.getWaitingConnections(
            token: token,
            // userPhoneNumber: d["data"]
            //     ["phoneNumber"],
            contact: parsedResponse["data"]["emailAddress"]);
        List waitingConns = waitingConnections['data'];
        dynamic data = waitingConns.singleWhere(
          (element) => element['_id'] == dynamicLinkID,
          orElse: () => null,
        );

        Get.offAll(() => WaitingView(
              data: data,
            ));
      }
      if (prefs.getString('dynamicLink') == null) {
        Get.offAll(() => HomeView(
              index: 1,
            ));
      }

      //all good
      return false;
    } else {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      if (response.statusCode == 401) {
        Get.offAll(AuthScreenView());
      }
      // error

      return false;
    }
  }

  Future<void> sendSupportEmail(
      {required String emailAddress,
      required String token,
      required String subject,
      required String emailContent,
      required BuildContext context}) async {
    var uri = Uri.parse("$url/api/sendSupportEmail");

    var body = {
      "emailAddress": emailAddress,
      "subject": subject,
      "emailContent": emailContent
    };

    /// Set options
    /// Max and msg required

    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(body));
    print(token);
    print("Victorhezzzz");
    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      print(parsedResponse);
      showPluhgDailog(
          context, "Great", "Your message has been sent successfully");

      //all good
    } else {
      // error

      showPluhgDailog(
          context, "So Sorry", "Couldn't send your message, try again letter");

      print("Error");
    }
  }

  Future connectTwoPeople(
      {required String requesterName,
      required String contactName,
      required String contactContact,
      required String requesterContact,
      required String requesterMessage,
      required String contactMessage,
      required String bothMessage,
      // required Uint8List? contactImage,
      // required Uint8List? requesterImage,
      required BuildContext context}) async {
    print(
        "Requester => $requesterName : $requesterContact \n Contact => $contactName : $contactContact");
    var uri = Uri.parse("$url/api/connect/people");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString("userID");

    String? token = prefs.getString("token");
    var body = {};
    body["userId"] = userID;
    body['both'] = bothMessage;

    if (contactContact.contains("@")) {
      body["contact"] = {"emailAddress": contactContact, "name": contactName};
    }
    if (!contactContact.contains("@")) {
      body["contact"] = {"phoneNumber": contactContact, "name": contactName};
    }
    if (requesterContact.contains("@")) {
      body["requester"] = {
        "emailAddress": requesterContact,
        "name": requesterName
      };
    }
    if (!requesterContact.contains("@")) {
      body["requester"] = {
        "phoneNumber": requesterContact,
        "name": requesterName
      };
    }
    print(body);

    /// Set options
    /// Max and msg required

    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(body));
    print(token);
    var parsedResponse = jsonDecode(response.body);
    // print(parsedResponse["data"]["_id"].toString());
    print("Connection ID");

    if (parsedResponse["hasError"] == false) {
      print(parsedResponse);
      Get.snackbar("Great", "You have connected them, about to send message");

      await connectTwoPeopleMessage(
          connectionID: parsedResponse["data"]["_id"].toString(),
          requestermessage: bothMessage.isEmpty
              ? "${prefs.getString("userName")} has recommeded a connection between you and One of Their Contacts. Click this link to log into Pluhg and respond to the connection " +
                  requesterMessage
              : bothMessage +
                  " " +
                  requesterMessage +
                  " Click this link to log into Pluhg and respond to ${prefs.getString("userName")}'s connection recommendation ",

          // : " ${prefs.getString("userName")} has recommeded a connection between you and One of ${prefs.getString("userName")}'s Contact. Click this link to log into Pluhg and response to ${prefs.getString("userName")}'s connection recommendation",
          contactmessage: bothMessage.isEmpty
              ? "${prefs.getString("userName")} has recommeded a connection between you and One of Their Contacts. Click this link to log into Pluhg and respond to the connection " +
                  contactMessage
              : bothMessage +
                  " " +
                  contactMessage +
                  " Click this link to log into Pluhg and respond to ${prefs.getString("userName")}'s connection recommendation ",
          // +
          //           " Click this link to log into Pluhg and response to ${prefs.getString("userName")}'s connection recommendation"
          //       : "${prefs.getString("userName")} has recommeded a connection between you and One of ${prefs.getString("userName")}'s Contact. Click this link to log into Pluhg and response to ${prefs.getString("userName")}'s connection recommendation",
          contactContact: contactContact,
          requesterContact: requesterContact,
          context: context);
      return true;

      //all good
    } else {
      // error
      Get.snackbar("So sorry", "Couldn't connect them");

      showPluhgDailog(
          context, "So Sorry", "Couldn't pluhg, Users already pluhged");

      print("Error");
    }
  }

  Future<void> connectTwoPeopleMessage(
      {required String requestermessage,
      required String contactmessage,
      required String contactContact,
      required String connectionID,
      required String requesterContact,
      required BuildContext context}) async {
    print("contact: $contactContact , requester: $requesterContact");
    var uriSMS = Uri.parse("$url/api/connect/connectPeople/sendSMS");
    var uriEmail = Uri.parse("$url/api/connect/connectPeople/sendEmail");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString("userID");

    String? token = prefs.getString("token");
    final DynamicLinkParameters _dynamicLinkParameters = DynamicLinkParameters(
        uriPrefix: "https://app.pluhg.com",
        link: Uri.parse("https://app.pluhg.com/?id=$connectionID"),
        androidParameters: AndroidParameters(
            packageName: "com.example.plug", minimumVersion: 0),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "Pluhg App", description: "You have been connected"));
    Uri uri;

    final ShortDynamicLink _shortDynamicLink =
        await _dynamicLinkParameters.buildShortLink();
    uri = _shortDynamicLink.shortUrl;

    var parsedResponse;

    print(
        'is email ? ${contactContact.contains("@") && requesterContact.contains("@")} \n ${contactContact.toString()} \n ${requesterContact.toString()}');

    if (contactContact.contains("@") && requesterContact.contains("@")) {
      print('both users using email');
      var body = {
        "plugedUser": userID,
        "sendEmail": [
          {
            "emailAddress": contactContact,
            "emailContent": contactmessage + " " + " " + " " + uri.toString()
          },
          {
            "emailAddress": requesterContact,
            "emailContent": requestermessage + " " + " " + uri.toString()
          }
        ]
      };
      print(body);
      var response = await http.post(uriEmail,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body));
      parsedResponse = jsonDecode(response.body);
      if (parsedResponse["hasError"] == false) {
        print(parsedResponse);
        Get.snackbar("Great ", "You have sent message successfully");

        showMessagePluhgDailog(context, "Great!!",
            "$requesterContact and $contactContact will be notified.  Don’t worry we will not share any contact details between them 🤐 ");

        //all good
      } else {
        showPluhgDailog(context, "So sorry!!",
            "Could not send messgae, check number format ");
        // return parsedResponse;
        Get.snackbar("So sorry ", "Couldn't send message, try sending message");
      }
    } else if (!contactContact.contains("@") &&
        !requesterContact.contains("@")) {
      var body = {
        "plugedUser": userID,
        "sendSMS": [
          {
            "phoneNumber": contactContact,
            "text": contactmessage + " " + " " + uri.toString(),
          },
          {
            "phoneNumber": requesterContact,
            "text": requestermessage + " " + " " + uri.toString(),
          },
        ]
      };
      print('body is $body');
      var response = await http.post(uriSMS,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body));
      parsedResponse = jsonDecode(response.body);
      print('parsedResponse is $parsedResponse');
      if (parsedResponse["hasError"] == false) {
        print(parsedResponse);
        Get.snackbar("Great ", "You have sent message successfully");

        showMessagePluhgDailog(context, "Great!!",
            "$requesterContact and $contactContact will be notified.  Don’t worry we will not share any contact details between them 🤐 ");
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HomeScreen(
        //               index: 1,
        //               userID: userID,
        //               token: token,
        //               // data: parsedResponse["data"],
        //             )));

        //all good
      } else {
        showPluhgDailog(context, "So sorry!!",
            "Could not send messgae, Number not supported by twilio  ");
        Get.snackbar("So sorry ", "Couldn't send message, try sending message");
      }
    } else if (contactContact.contains("@") != requesterContact.contains("@")) {
      if (contactContact.contains("@")) {
        var body = {
          "plugedUser": userID,
          "sendEmail": [
            {
              "emailAddress": contactContact,
              "emailContent": contactmessage + " " + " " + uri.toString()
            },
          ]
        };
        print(body);
        var response = await http.post(uriEmail,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(body));
        parsedResponse = jsonDecode(response.body);
        if (parsedResponse["hasError"] == false) {
          print(parsedResponse);
          Get.snackbar("Great ", "You have sent message successfully");

          showMessagePluhgDailog(context, "Great!!",
              "$requesterContact and $contactContact will be notified.  Don’t worry we will not share any contact details between them 🤐 ");
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => HomeScreen(
          //               index: 1,
          //               userID: userID,
          //               token: token,
          //               // data: parsedResponse["data"],
          //             )));

          //all good
        } else {
          showPluhgDailog(context, "So sorry!!",
              "Could not send messgae, check number format ");
          Get.snackbar(
              "So sorry ", "Couldn't send message, try sending message");
        }
      } else if (!contactContact.contains("@")) {
        var body = {
          "plugedUser": userID,
          "sendSMS": [
            {
              "phoneNumber": contactContact,
              "text": contactmessage + " " + " " + uri.toString(),
            },
          ]
        };
        print(body);
        var response = await http.post(uriSMS,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(body));
        parsedResponse = jsonDecode(response.body);
        if (parsedResponse["hasError"] == false) {
          print(parsedResponse);
          Get.snackbar("Great ", "You have sent message successfully");

          showMessagePluhgDailog(context, "Great!!",
              "$requesterContact and $contactContact will be notified.  Don’t worry we will not share any contact details between them 🤐 ");
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => HomeScreen(
          //               index: 1,
          //               userID: userID,
          //               token: token,
          //               // data: parsedResponse["data"],
          //             )));

          //a
          //ll good
        } else {
          showPluhgDailog(context, "So sorry!!",
              "Could not send messgae, check number format ");
          Get.snackbar(
              "So sorry ", "Couldn't send message, try sending message");
        }
      }
      if (requesterContact.contains("@")) {
        var body = {
          "plugedUser": userID,
          "sendEmail": [
            {
              "emailAddress": requesterContact,
              "emailContent": requestermessage + " " + " " + uri.toString()
            },
          ]
        };
        print(body);
        var response = await http.post(uriEmail,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(body));
        parsedResponse = jsonDecode(response.body);
      } else if (!requesterContact.contains("@")) {
        var body = {
          "plugedUser": userID,
          "sendSMS": [
            {
              "phoneNumber": requesterContact,
              "text": requestermessage + " " + " " + uri.toString(),
            },
          ]
        };
        print(body);
        var response = await http.post(uriSMS,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(body));
        parsedResponse = jsonDecode(response.body);
        if (parsedResponse["hasError"] == false) {
          print(parsedResponse);
          Get.snackbar("Great ", "You have sent message successfully");

          showMessagePluhgDailog(context, "Great!!",
              "$requesterContact and $contactContact will be notified.  Don’t worry we will not share any contact details between them 🤐 ");
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => HomeScreen(
          //               index: 1,
          //               userID: userID,
          //               token: token,
          //               // data: parsedResponse["data"],
          //             )));

          //all good
        } else {
          showPluhgDailog(context, "So sorry!!",
              "Could not send messgae, check number format");
          Get.snackbar(
              "So sorry ", "Couldn't send message, try sending message");
        }
      }
      print(parsedResponse);
    }
    print(parsedResponse);
  }

  Future<void> sendReminderMessage(
      {required String message,
      required String contactContact,
      required BuildContext context}) async {
    print("contact: $contactContact");
    var uriSMS = Uri.parse("$url/api/connect/connectPeople/sendSMS");
    var uriEmail = Uri.parse("$url/api/connect/connectPeople/sendEmail");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString("userID");
    ProgressDialog pd = ProgressDialog(context: context);
    String? token = prefs.getString("token");
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressBgColor: Colors.transparent,
    );
    if (contactContact.contains("@")) {
      var body = {
        "plugedUser": userID,
        "sendEmail": [
          {"emailAddress": contactContact, "emailContent": message},
        ]
      };
      print(body);
      var response = await http.post(uriEmail,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body));
      parsedResponse = jsonDecode(response.body);
    } else if (!contactContact.contains("@")) {
      var body = {
        "plugedUser": userID,
        "sendSMS": [
          {
            "phoneNumber": contactContact,
            "text": message,
          },
        ]
      };
      print(body);
      var response = await http.post(uriSMS,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body));
      parsedResponse = jsonDecode(response.body);
    }
    print(parsedResponse);

    /// Set options
    /// Max and msg required

    if (parsedResponse["hasError"] == false) {
      pd.close();
      print(parsedResponse);
      showPluhgDailog(context, "Success", "You have sent a reminder");

      //all good
    } else {
      // error
      pd.close();
      showPluhgDailog(
          context, "So sorry", "Couldn't complete your request, try again");

      print("Error");
    }
  }

  Future getProfile({required String token, required String userID}) async {
    var uri = Uri.parse("$url/api/profileDetails/$userID");

    var response =
        await http.get(uri, headers: {"Authorization": "Bearer $token"});

    var parsedResponse = jsonDecode(response.body);
    print(parsedResponse);
    if (response.statusCode == 401) {
      pluhgSnackBar("So sorry", "You have to login again, session expired");
      Get.offAll(() => AuthScreenView());
    }
    if (parsedResponse["hasError"] == false) {
      return parsedResponse;
      // all good, details in parsedResponse
    } else {
      return parsedResponse;
    }
  }

  void setProfile(
      {required String token,
      required String userID,
      String name = "",
      String address = ""}) async {
    var uri = Uri.parse("$url/api/updateProfileDetails/$userID");

    var body = {};

    if (name != "") {
      body["name"] = name;
    }

    if (address != "") {
      body["address"] = address;
    }

    var response = await http.post(uri,
        headers: {"Authorization": "Bearer $token"}, body: body);

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      //All okay
    } else {
      //ERROR
    }
  }

  Future<bool> setProfile2({
    required String? token,
    required String? userID,
    String name = "",
    String userName = "",
    String address = "",
    required String phone,
    required String email,
    required BuildContext context,
  }) async {
    var uri = Uri.parse("$url/api/updateProfileDetails/$userID");

    var body = {};
    if (email != "nothing") {
      body["emailAddress"] = email;
    }
    if (name != "nothing") {
      body["name"] = name;
    }

    if (userName != "nothing") {
      body["userName"] = userName;
    }
    if (address != "nothing") {
      body["address"] = address;
    }
    if (phone != "nothing") {
      body["phoneNumber"] = phone;
    }

    var response = await http.post(uri,
        headers: {"Authorization": "Bearer $token"}, body: body);

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      // All okay

      Future.delayed(Duration(microseconds: 7000), () {
        Get.offAll(() => HomeView(
              index: 3,
            ));
      });
      return false;
    } else {
      //ERROR
      pluhgSnackBar("So sorry", parsedResponse["message"].toString());
      // pr.hide();
      return false;
    }
  }

  Future<bool> updateProfile(
    var imageFile, {
    required String token,
    required var data,
    required String userID,
    required BuildContext context,
  }) async {
    var stream = http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse("$url/api/updateProfileDetails/$userID");
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    var request = http.MultipartRequest("POST", uri)
      // ..fields["name"] = name
      // ..fields["address"] = address
      // ..fields["numberOfConnections"] = numberofConnection
      // ..fields["emailAddress"] = emailAddress + "7y"
      // ..fields["phoneNumber"] = phoneNumber + "29"
      ..files.add(http.MultipartFile('profileImage', stream, length,
          filename: basename(imageFile.path),
          contentType: MediaType('image', 'png')))
      ..headers.addAll(headers);

    //contentType: new MediaType('image', 'png'));

    var response = await request.send();
    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((var value) async {
      print(value);
      print(response);
      var jar = response.stream.transform(utf8.decoder);
    });
    if (response.statusCode == 200) {
      Future.delayed(Duration(microseconds: 7000), () {
        Get.offAll(() => HomeView(
              index: 3,
            ));
      });
      Get.snackbar("Great", "You have changed your picture");
      return false;
    } else {
      pluhgSnackBar("So Sorry", response.reasonPhrase.toString());
      return false;
    }
  }

  dynamic getNotificationSettings({
    required String token,
    required String userID,
  }) async {
    var uri = Uri.parse("$url/api/notification/settings/$userID");
    // NotificationSettings settingz;
    var response =
        await http.get(uri, headers: {"Authorization": "Bearer $token"});

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      print("vICTORHEZ CORRCTION");
      print(parsedResponse);
      return parsedResponse;
      //All okay
    } else {
      //ERROR
      // showPluhgDailog(context, "Error", parsedResponse["message"].toString());
    }
  }

  void updateNotificationSettings({
    required String token,
    required String userID,
    required BuildContext context,
    required bool pushNotification,
    required bool textNotification,
    required bool emailNotification,
  }) async {
    var uri = Uri.parse("$url/api/notification/settings/update");
    var body = {
      "userId": userID,
      "textNotification": textNotification,
      "emailNotification": emailNotification,
      "pushNotification": pushNotification
    };

    var response = await http.post(uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body));

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      showPluhgDailog(
          context, "Great!!!", "Notification  settings has been updated");
      print(parsedResponse);
      //All okay
    } else {
      //ERROR

      print("Victorhez notification update successful");
      showPluhgDailog(context, "Message", "Try again");
      print(parsedResponse);
    }
  }

//For Connections Screen
  Future<dynamic> getRecommendedConnections({
    required String token,
    required String userID,
  }) async {
    Uri uri = Uri.parse("$url/api/connect/whoIconnected/$userID");
    var response;
    try {
      response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
    } catch (e) {
      print("API has Error");
      print("Error: ");
      print(e);
      return null;
    }

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      print("All Good Here");
      print(parsedResponse);
      return parsedResponse;
      //All okay
    } else {
      print("Ran into Error");
      print(parsedResponse);
      return null;
    }
  }

  Future<dynamic> getActiveConnections({
    required String token,
    required String contact,
  }) async {
    Uri uri = Uri.parse("$url/api/connect/activeConnections");
    var response;
    try {
      response = await http.post(uri,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "${!contact.contains("@") ? "phoneNumber" : "emailAddress"}":
                "${contact.toString()}",
          }));
      print('response ${response.body}');
    } catch (e) {
      print("API has Error");
      print("Error: ");
      print(e);
      return null;
    }

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      print("All Good Here");
      print(parsedResponse);
      return parsedResponse;
      //All okay
    } else {
      print("Ran into Error");
      print(parsedResponse);
      Get.snackbar("So Sorry", "Error Occured");
    }
  }

  Future<dynamic> getWaitingConnections({
    required String token,
    required String contact,
  }) async {
    print(token);
    Uri uri = Uri.parse("$url/api/connect/waitingConnections");
    http.Response response;

    response = await http.post(uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "${!contact.contains("@") ? "phoneNumber" : "emailAddress"}":
              "${contact.toString()}",
        }));
    print('response ${response.body}');

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["hasError"] == false) {
      print("All Good Here");
      print(parsedResponse);
      return parsedResponse;
      //All okay
    } else {
      print("Ran into Error");
      print(parsedResponse);
      Get.snackbar("So Sorry", "Error Occured");

      // return null;
    }
  }

  Future<bool> respondToConnectionRequest({
    required String contact,
    required BuildContext context,
    required String plugID,
    required bool isAccepting,
    required bool isRequester,
    required bool isContact,
    required String connectionID,
  }) async {
    print("contact: $contact");
    var uri = Uri.parse("$url/api/connect/acceptOrRejectConnection");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ProgressDialog pd = ProgressDialog(context: context);
    String? token = prefs.getString("token");
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressBgColor: Colors.transparent,
    );
    if (contact.contains("@")) {
      var body = {
        "connectionId": connectionID,
        "pluhggedBy": plugID,
        "acceptRequest": isAccepting,
        "isRequester": isRequester,
        "isContact": isContact,
        "emailAddress": contact
      };
      print(body);
      var response = await http.post(uri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body));
      parsedResponse = jsonDecode(response.body);
    } else if (!contact.contains("@")) {
      var body = {
        "connectionId": connectionID,
        "pluhggedBy": plugID,
        "acceptRequest": isAccepting,
        "isRequester": isRequester,
        "isContact": isContact,
        "phoneNumber": contact
      };
      print(body);
      var response = await http.post(uri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body));
      parsedResponse = jsonDecode(response.body);
    }
    print(parsedResponse);

    if (parsedResponse["hasError"] == false) {
      pd.close();
      print(parsedResponse);
      showPluhgDailog2(context, "Success",
          "You have successfully ${isAccepting ? "accepted" : "rejected"} this  connection",
          onCLosed: () {});

      //all good
    } else {
      // error
      pd.close();
      showPluhgDailog(context, "So sorry", parsedResponse["message"]);
      Get.snackbar("So sorry", parsedResponse["message"]);

      print("Error");
    }

    return !parsedResponse["hasError"];
  }

  Future<bool> closeConnection({
    required String connectionID,
    required BuildContext context,
  }) async {
    print("connection ID: $connectionID");
    var uri = Uri.parse("$url/api/connect/closeConnection");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString("userID");
    ProgressDialog pd = ProgressDialog(context: context);
    String? token = prefs.getString("token");
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressBgColor: Colors.transparent,
    );
    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(
        {"connectionId": connectionID},
      ),
    );
    parsedResponse = jsonDecode(response.body);

    print(parsedResponse);

    if (parsedResponse["hasError"] == false) {
      pd.close();
      print(parsedResponse);
      showPluhgDailog2(context, "Great!!!",
          "You have successfully cancelled this  connection", onCLosed: () {
        Navigator.pop(context);
      });
      return true;

      //all good
    } else {
      // error
      pd.close();
      showPluhgDailog(
          context, "So sorry", "Couldn't complete your request, try again");

      print("Error");
      return false;
    }
  }

  Future checkPluhgUsers({
    required String contact,
    required String name,
  }) async {
    var uri = Uri.parse("$url/api/checkIsPlughedUser");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    var parsedResponse;

    Map body = {};
    if (contact.contains("@")) {
      body = {
        "contacts": [
          {"name": name, "emailaddress": contact.trim()}
        ]
      };
    } else {
      body = {
        "contacts": [
          {"name": name, "phoneNumber": contact.trim()}
        ]
      };
    }
    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
    print(token);
    parsedResponse = jsonDecode(response.body);

    print(parsedResponse);

    if (parsedResponse["hasError"] == false) {
      print(parsedResponse);
      return parsedResponse["data"][0]["isPlughedUser"];

      //all good
    } else {
      // error

      print("Error");
    }
  }

  Future<dynamic> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');
    String? token = prefs.getString('token');
    if (userId != null) {
      var uri = Uri.parse("$url/api/getNotificationList/$userId");

      var response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
      var parsedResponse = jsonDecode(response.body);
      print(parsedResponse);
      return parsedResponse["data"];
    } else {
      print("error");
      return null;
    }
  }

  Future<dynamic> getConnectionDetails({required String connectionID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      ///api/connect/getconnectionsDetails/
      print('connectionID is $connectionID');
      var uri = Uri.parse("$url/api/getconnectionsDetails/$connectionID");
      print('uri ${uri.toString()}');
      var response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
      print('1250 response ${response.body}');
      var parsedResponse = jsonDecode(response.body);
      print(parsedResponse);
      return parsedResponse["data"];
    } else {
      print("error");
    }
  }

  Future<dynamic> uploadFile(String senderId, List<String> files) async {
    // api/upload/uploadFile/{senderId}
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MGY3OWY5NGUxYWI2YzMwZmM5MTJkODEiLCJwaG9uZSI6IjcyMjY4MjYyNjQiLCJpYXQiOjE2MjY4NDEwMTcsImV4cCI6MTYyNzAxMzgxN30.nRIF6kLCXC7YZZZkSAItXJgabDLJacc0fBQXcHqs_uI';
    // var uri = Uri.parse("$url/api/upload/uploadFile/$senderId");
    // var body = files;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$url/api/upload/uploadFile/$senderId"),
    );
    List<http.MultipartFile> iterable = [];
    for (int i = 0; i < files.length; i++) {
      iterable.add(await http.MultipartFile.fromPath('file', files[i]));
    }

    request.files.addAll(iterable);
    request.headers.addAll({
      "Authorization": "Bearer $token",
      'Content-type': 'multipart/form-data',
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    // var response = await http.post(uri,
    //     headers: {
    //       "Content-Type": "application/form-data",
    //       "Authorization": "Bearer $token"
    //     },
    //     body: body);
    // var parsedResponse = jsonDecode(response.body);
    // print(parsedResponse);
    if (data["hasError"] == false)
      return data['data']['fileName'];
    else
      return null;
  }
}
