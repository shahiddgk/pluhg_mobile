import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:plug/app/modules/auth_screen/views/auth_screen_view.dart';
import 'package:plug/app/modules/auth_screen/views/otp_screen.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/app/modules/home/views/home_view.dart';
import 'package:plug/app/modules/profile_screen/views/set_profile_screen.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/app/widgets/status_screen.dart';
import 'package:plug/models/recommendation_response.dart';
import 'package:plug/utils/validation_mixin.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class APICALLS with ValidationMixin {
  static const url = "http://3.18.123.250";

  late Size screenSize;
  static const imageBaseUrl = 'https://pluhg.s3.us-east-2.amazonaws.com/';

  ///API to login or sign up.
  Future<bool> signUpSignIn({String? contact}) async {
    var uri = Uri.parse("$url/api/login");

    var body = {
      'emailAddress': contact!.contains("@") ? contact : '',
      'phoneNumber': !contact.contains("@") ? contact : '',
      'type': contact.contains("@") ? 'email' : 'phone'
    };

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

  //Verify OTP
  Future<bool> verifyOTP(
      {required String contact,
      required BuildContext context,
      required String code,
      required String fcmToken}) async {
    var uri = Uri.parse("$url/api/verifyOTP");
    bool success;
    var body = {
      "emailAddress": contact.contains("@") ? contact : "",
      "phoneNumber": !contact.contains("@") ? contact : "",
      "code": code,
      "type": contact.contains("@") ? "email" : 'phone',
      "deviceToken": fcmToken
    };

    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

    var parsedResponse = jsonDecode(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      pluhgSnackBar('Great', 'Successfully logged in');
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
        prefs.setBool(prefloggedout, false);
        print(parsedResponse['data']['token'].toString());
        prefs.setString(preftoken, parsedResponse['data']['token'].toString());
        prefs.setString(
            prefuserid, parsedResponse['data']['user']['data']['_id'].toString());
        prefs.setString(
            prefusername, parsedResponse['data']['user']['data']['userName'].toString());
        prefs.setString(
            prefuseremail, parsedResponse['data']['user']['data']['emailAddress'].toString());
        prefs.setString(
            prefuserphone, parsedResponse['data']['user']['data']['phoneNumber'].toString());
        Get.offAll(() => HomeView(
              index: 1.obs,
            ));
      }
      return false;
    } else {
      pluhgSnackBar('Sorry', parsedResponse['message'].toString());
      return false;
    }
  }

  Future<bool> createProfile(
      {required String token,
      required String contact,
      required String contactType,
      required String username}) async {
    var uri = Uri.parse("$url/api/createProfile");

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

    if (response.statusCode == 200) {
      pluhgSnackBar('Great', 'Your profile Has been set');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('profileImage',
      //     parsedResponse["data"]["userData"]["profileImage"].toString()); //TODO check the data it returns

      prefs.setString('token', token);
      prefs.setString('userName', username);
      prefs.setBool("logged_out", false);
      prefs.setString(
          !contact.contains("@") ? "phoneNumber" : "emailAddress", contact);

      Get.offAll(() => HomeView(
            index: 1.obs,
          ));
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

  Future<bool> connectTwoPeople(
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
    var uri = Uri.parse("$url/api/connect/people");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(preftoken);

    var body = {
      "requester": {
        "name": requesterName,
        "contact": requesterContact,
        "contactType": requesterContact.contains("@") ? 'email' : 'phone',
        "message":
            "${prefs.getString(prefusername)} has recommeded a connection between you and One of Their Contacts. Click this link to log into Pluhg and respond to the connection. \n$bothMessage \n$requesterMessage "
      },
      "contact": {
        "name": contactName,
        "contact": contactContact,
        "contactType": contactContact.contains("@") ? 'email' : 'phone',
        "message":
            "${prefs.getString(prefusername)} has recommeded a connection between you and One of Their Contacts. Click this link to log into Pluhg and respond to the connection. \n$bothMessage \n$contactMessage "
      },
      'generalMessage': bothMessage
    };

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
    bool bothemail =
        requesterContact.contains("@") && contactContact.contains("@");
    bool bothphone =
        !requesterContact.contains("@") && !contactContact.contains("@");
    if (parsedResponse["status"] == true) {
      print(parsedResponse);
      pluhgSnackBar("Great", "You have connected them, about to send message");

      Get.off(StatusScreen(
          buttonText: "Continue",
          heading: 'Connection Successful',
          iconName: 'success_status',
          onPressed: () => Get.offAll(HomeView(
                index: 0.obs,
              )),
          subheading: bothemail
              ? "$requesterName in phone and $contactName in phone will be notified by email of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐"
              : bothphone
                  ? "$requesterName in phone and $contactName in phone will be notified by text of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐"
                  : "$requesterName in Phone will be notified by ${requesterContact.contains("@") ? "email" : "phone"} and $contactName in phone will be notified by ${contactContact.contains("@") ? "email" : "phone"} of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐 "));

      return false;

      //all good
    } else {
      // error
      pluhgSnackBar("So sorry", "${parsedResponse['message']}");

      return false;
    }
  }

  Future<bool> sendReminderMessage(
      {required String message,
      required String party,
      required String connectionID,
      required BuildContext context}) async {
    var uri = Uri.parse("$url/api/connect/sendReminder");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    ProgressDialog pd = ProgressDialog(context: context);
    String? token = prefs.getString(preftoken);
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
      progressBgColor: Colors.transparent,
    );

    var body = {
      'connectionId': connectionID,
      'message': message,
      'party': party
    };

    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(body));
    parsedResponse = jsonDecode(response.body);

    /// Set options
    /// Max and msg required

    if (parsedResponse["status"]) {
      pd.close();
      print(parsedResponse);
      return true;
      //all good
    } else {
      // error
      pd.close();
      return false;
    }
  }

  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(preftoken).toString();
    var uri = Uri.parse("$url/api/profileDetails");
    var response =
        await http.get(uri, headers: {"Authorization": "Bearer $token"});

    var parsedResponse = jsonDecode(response.body);
    print(parsedResponse);
    if (response.statusCode == 401) {
      pluhgSnackBar("So sorry", "You have to login again, session expired");
      Get.offAll(() => AuthScreenView());
    } else if (response.statusCode == 200) {
      return parsedResponse;
      // all good, details in parsedResponse
    } else {
      return null;
    }
  }

  void setProfile(
      {required String token, String name = "", String address = ""}) async {
    var uri = Uri.parse("$url/api/updateProfileDetails");

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
    String name = "",
    String userName = "",
    String address = "",
    required String phone,
    required String email,
    required BuildContext context,
  }) async {
    var uri = Uri.parse("$url/api/updateProfileDetails");

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

    if (parsedResponse["status"] == true) {
      // All okay

      Get.offAll(() => HomeView(
            index: 3.obs,
          ));
      pluhgSnackBar("Great", "You have changed your profile details");

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
    required BuildContext context,
  }) async {
    var stream = http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse("$url/api/uploadProfileImage");
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

    response.stream.transform(utf8.decoder).listen((var value) async {

      var jar = response.stream.transform(utf8.decoder);
    });
    if (response.statusCode == 200) {
      Future.delayed(Duration(microseconds: 10000), () {
        Get.offAll(() => HomeView(
              index: 3.obs,
            ));
        pluhgSnackBar("Great", "You have changed your picture");
      });

      return false;
    } else {
      pluhgSnackBar("So Sorry", response.reasonPhrase.toString());
      return false;
    }
  }

  dynamic getNotificationSettings({
    required String token,
  }) async {
    var uri = Uri.parse("$url/api/notification/settings");
    // NotificationSettings settingz;
    var response =
        await http.get(uri, headers: {"Authorization": "Bearer $token"});

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["status"] == true) {
      print(parsedResponse);
      return parsedResponse;
      //All okay
    } else {
      return null;
      //ERROR
      // showPluhgDailog(context, "Error", parsedResponse["message"].toString());
    }
  }

  Future<bool> updateNotificationSettings({
    required String token,
    required BuildContext context,
    required bool pushNotification,
    required bool textNotification,
    required bool emailNotification,
  }) async {
    var uri = Uri.parse("$url/api/notification/settings/update");
    var body = {
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

    if (response.statusCode == 200) {
      pluhgSnackBar("Great", "${parsedResponse['message']}");
      return false;
      //All okay
    } else {
      //ERROR

      print("Victorhez notification update successful");
      pluhgSnackBar("Sorry", "${parsedResponse['message']}");
      return false;
    }
  }

//For Connections Screen
  Future<dynamic> getRecommendedConnections({
    required String token,
    required String userID,
  }) async {


    Uri uri = Uri.parse("$url/api/connect/whoIconnected");
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

    if (parsedResponse["status"] == true) {
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
      response = await http.get(uri,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
       );

    } catch (e) {
      print("API has Error");
      print("Error: ");
      print(e);
      return null;
    }

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["status"] == true) {
      print("All Good Here");
      print(parsedResponse);
      return parsedResponse;
      //All okay
    } else {
      print("Ran into Error");
      print(parsedResponse);
      pluhgSnackBar("So Sorry", "${parsedResponse['message']}");
      return null;
    }
  }

  Future<dynamic> getWaitingConnections({
    required String token,
    required String contact,
  }) async {
    print(token);
    Uri uri = Uri.parse("$url/api/connect/waitingConnections");
    print("$url/api/connect/waitingConnections");

    http.Response response;

    response = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });
    print('response ${response.body}');

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["status"] == true) {
      return parsedResponse;
      //All okay
    } else {
      print("Ran into Error");
      print(parsedResponse);
      // pluhgSnackBar("So Sorry", "${parsedResponse['message']}");

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
    String? token = prefs.getString(preftoken);
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
      progressBgColor: Colors.transparent,
    );
    // if (contact.contains("@")) {
    var body = {
      "connectionId": connectionID,
      "action": isAccepting ? "accept" : "reject",
    };
    print(body);
    var response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(body));
    parsedResponse = jsonDecode(response.body);
    // }
    // else if (!contact.contains("@")) {
    //   var body = {
    //     "connectionId": connectionID,
    //     "pluhggedBy": plugID,
    //     "acceptRequest": isAccepting,
    //     "isRequester": isRequester,
    //     "isContact": isContact,
    //     "phoneNumber": contact
    //   };
    //   print(body);
    //   var response = await http.post(uri,
    //       headers: {
    //         "Content-Type": "application/json",
    //         "Authorization": "Bearer $token"
    //       },
    //       body: jsonEncode(body));
    //   parsedResponse = jsonDecode(response.body);
    // }
    print("ACCEPT_REJECT"+parsedResponse.toString());

    if (parsedResponse["status"] == true) {
      pd.close();
      print(parsedResponse);
      showPluhgDailog2(context, "Success",
          "You have successfully ${isAccepting ? "accepted" : "rejected"} this  connection",
          onCLosed: () {
        Get.off(HomeView(
          index: 2.obs,
        ));
      });

      //all good
      return false;
    } else {
      // error
      pd.close();

      pluhgSnackBar("So sorry", parsedResponse["message"]);

      print("Error");
      return false;
    }
  }

  Future<bool> closeConnection({
    required String connectionID,
    required BuildContext context,
  }) async {
    print("connection ID: $connectionID");
    var uri = Uri.parse("$url/api/connect/closeConnection");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ProgressDialog pd = ProgressDialog(context: context);
    String? token = prefs.getString(preftoken);
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
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

  Future<List<PluhgContact>> checkPluhgUsers(
      {required List<PluhgContact> contacts}) async {
    var uri = Uri.parse("$url/api/checkIsPlughedUser");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(preftoken);

    Map body = {
      "contacts": contacts.map((item) => item.toCleanedJson()).toList()
    };

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
    Map parsedResponse = jsonDecode(response.body);

    print(parsedResponse);
    List data = parsedResponse['data'];
    for (int i = 0; i < data.length; i++) {
      final user = data[i] as Map<String, dynamic>;
      final userPhoneNumber = formatPhoneNumber(user['phoneNumber'] as String);

      final registeredContacts = contacts.where((c) {
        final contactPhoneNumber = formatPhoneNumber(c.phoneNumber);
        return contactPhoneNumber == userPhoneNumber;
      });

      registeredContacts.forEach((rc) {
        rc.isPlughedUser = true;
      });
    }
    return contacts;
  }

  Future<dynamic> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(preftoken);

    var uri = Uri.parse("$url/api/getNotificationList");

    var response =
        await http.get(uri, headers: {"Authorization": "Bearer $token"});
    var parsedResponse = jsonDecode(response.body);
    print(parsedResponse);
    return parsedResponse["data"];
    //TODO Work on this
  }

  ///to get connection details used in dynamic for milestone one
  Future<RecommendationResponse> getConnectionDetails(
      {required String connectionID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(preftoken);
    print('connectionID is $connectionID');
    print('connection id $token');
    var uri = Uri.parse("$url/api/connect/getconnectionsDetails/$connectionID");
    print('uri ${uri.toString()}');
    var response =
        await http.get(uri, headers: {"Authorization": "Bearer $token"});
    print(response.body);
    Map<String, dynamic> map = jsonDecode(response.body);
    return RecommendationResponse.fromJson(map);
  }

  Future<dynamic> uploadFile(String senderId, List<String> files) async {
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MGY3OWY5NGUxYWI2YzMwZmM5MTJkODEiLCJwaG9uZSI6IjcyMjY4MjYyNjQiLCJpYXQiOjE2MjY4NDEwMTcsImV4cCI6MTYyNzAxMzgxN30.nRIF6kLCXC7YZZZkSAItXJgabDLJacc0fBQXcHqs_uI';

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

    if (data["hasError"] == false)
      return data['data']['fileName'];
    else
      return null;
  }
}
