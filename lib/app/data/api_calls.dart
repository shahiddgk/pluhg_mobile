import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/app/widgets/status_screen.dart';
import 'package:plug/constants/app_constants.dart';
import 'package:plug/models/file_model.dart';
import 'package:plug/models/notification_response.dart';
import 'package:plug/models/recommendation_response.dart';
import 'package:plug/utils/validation_mixin.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class APICALLS with ValidationMixin {
  static const url = "https://api.pluhg.com";
  static const ws_url = "ws://api.pluhg.com";

  //static const url = "http://localhost:3001";
  //static const ws_url = "ws://localhost:3001";

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

    var response = await http.post(uri, body: jsonEncode(body), headers: {
      "Content-Type": "application/json"
    }).timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });
    var parsedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("[signUpSignIn] success: ${parsedResponse['message']}");
      pluhgSnackBar('Great', parsedResponse['message'].toString());
      Get.to(() => OTPScreenView(contact: contact));
      return true;
    }

    print("[signUpSignIn] error: ${parsedResponse['message']}");
    pluhgSnackBar('Sorry', parsedResponse['message'].toString());
    return false;
  }

  //Verify OTP
  Future<bool> verifyOTP({
    required String contact,
    required BuildContext context,
    required String code,
    required String fcmToken,
  }) async {
    //@todo need to move to some request DTO instead
    var body = {
      "emailAddress": EmailValidator.validate(contact) ? contact : "",
      "phoneNumber": PhoneValidator.validate(contact) ? contact : "",
      "code": code,
      "type": EmailValidator.validate(contact)
          ? User.EMAIL_CONTACT_TYPE
          : User.PHONE_CONTACT_TYPE,
      "deviceToken": fcmToken.toString()
    };

    var uri = Uri.parse("$url/api/verifyOTP");
    var response = await http
        .post(uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });
    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final errorMessage = parsedResponse['message'].toString();

      print("[verifyOTP] error: $errorMessage");
      pluhgSnackBar('Sorry', errorMessage);

      return false;
    }

    print("[verifyOTP] Successfully logged in");
    pluhgSnackBar('Great', 'Successfully logged in');
    final token = parsedResponse['data']['token'].toString();
    final userData = parsedResponse['data']['user']['data'];

    print(
        "[verifyOTP] is registered: ${parsedResponse['data']['user']['isRegistered']}");
    final isRegistered = parsedResponse['data']['user']['isRegistered'] == true;

    final isUserEmailEmpty = userData['emailAddress'] == null;
    final isUserNameEmpty = userData['userName'] == null;

    print("[verifyOTP] user data: ${userData.toString()}");

    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setBool(PREF_IS_FIRST_APP_RUN, false);
    print("[verifyOTP] PREF_IS_FIRST_APP_RUN: false");

    /*if(isUserEmailEmpty && isUserNameEmpty){

    }*/
    if (isRegistered && !isUserEmailEmpty && !isUserNameEmpty) {
      User user = await UserState.get();
      await UserState.store(
        User.registered(
          token: token,
          id: userData['_id'].toString(),
          name: userData['userName'].toString(),
          phone: userData['phoneNumber'].toString(),
          email: userData['emailAddress'].toString(),
          countryCode: user.countryCode.isNotEmpty
              ? user.countryCode
              : User.DEFAULT_COUNTRY_CODE,
        ),
      );

      Get.offAll(() => HomeView(index: 1.obs));
      return true;
    }

    Get.offAll(() => SetProfileScreenView(
          token: token,
          userID: userData['_id'].toString(),
          contact: userData['emailAddress'] == null
              ? userData['phoneNumber'].toString()
              : userData['emailAddress'].toString(),
        ));

    return true;
  }

  // save users informations / Create Profile
  Future<bool> createProfile({
    required String token,
    required String contact,
    required String contactType,
    required String username,
  }) async {
    var uri = Uri.parse("$url/api/createProfile");

    var body = {"userName": username};
    if (User.isEmailContactType(contactType)) {
      body["emailAddress"] = contact;
    }
    if (User.isPhoneContactType(contactType)) {
      body["phoneNumber"] = contact;
    }

    String requestBody = jsonEncode(body);
    print("[Api:createProfile] send request [$requestBody]");
    var response = await http
        .post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: requestBody,
    )
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);
    print("[Api:createProfile] response [$parsedResponse]");

    if (response.statusCode == 200) {
      pluhgSnackBar('Great', 'Your profile Has been set');
      User user = await UserState.get();
      await UserState.storeNewProfile(
          token: token,
          name: username,
          contact: contact,
          countryCode: user.countryCode);

      Get.offAll(() => HomeView(index: 1.obs));
      return false;
    } else {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      if (response.statusCode == 401) {
        Get.offAll(() => AuthScreenView());
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
    User user = await UserState.get();
    var response = await http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${user.token}"
            },
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return;
    }

    if (parsedResponse["status"] == true) {
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

  // Connect two People API
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
    User user = await UserState.get();

    var body = {
      "requester": {
        "name": requesterName,
        "contact": requesterContact,
        "contactType": requesterContact.contains("@") ? 'email' : 'phone',
        "message":
            "${user.name} has recommeded a connection between you and One of Their Contacts. Click this link to log into Pluhg and respond to the connection. \n$bothMessage \n$requesterMessage "
      },
      "contact": {
        "name": contactName,
        "contact": contactContact,
        "contactType": contactContact.contains("@") ? 'email' : 'phone',
        "message":
            "${user.name} has recommeded a connection between you and One of Their Contacts. Click this link to log into Pluhg and respond to the connection. \n$bothMessage \n$contactMessage "
      },
      'generalMessage': bothMessage
    };

    var response = await http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${user.token}"
            },
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return false;
    }

    // print(parsedResponse["data"]["_id"].toString());
    bool bothemail =
        requesterContact.contains("@") && contactContact.contains("@");
    bool bothphone =
        !requesterContact.contains("@") && !contactContact.contains("@");
    if (parsedResponse["status"] == true) {
      pluhgSnackBar("Great", "You have connected them, about to send message");

      Get.off(
        StatusScreen(
          buttonText: "Continue",
          heading: 'Connection Successful',
          iconName: 'success_status',
          onPressed: () => Get.offAll(HomeView(
            index: 0.obs,
            isDeepLinkCodeExecute: false,
            connectionTabIndex: 2,
          )),
          subheading: bothemail
              ? "$requesterName and $contactName will be notified by email of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐"
              : bothphone
              ? "$requesterName and $contactName will be notified by text of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐"
              : "$requesterName will be notified by ${requesterContact.contains("@") ? "email" : "phone"} AND $contactName will be notified by ${contactContact.contains("@") ? "email" : "phone"} of your CONNECTION RECOMMENDATIOIN!  Don't worry we will not share any personal contact details between them 🤐 ",

          /*subheading: bothemail
              ? "$requesterName in phone and $contactName in phone will be notified by email of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐"
              : bothphone
                  ? "$requesterName in phone and $contactName in phone will be notified by text of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐"
                  : "$requesterName in Phone will be notified by ${requesterContact.contains("@") ? "email" : "phone"} and $contactName in phone will be notified by ${contactContact.contains("@") ? "email" : "phone"} of your connections recommendation.  Don't worry we will not share any personal contact details between them 🤐 ",*/
        ),
      );

      return false;

      //all good
    } else {
      print(parsedResponse['message']);
      // error
      pluhgSnackBar("So sorry", "${parsedResponse['message']}");

      return false;
    }
  }

  // send Message to remind user
  Future<bool> sendReminderMessage(
      {required String message,
      required String party,
      required String connectionID,
      required BuildContext context}) async {
    var uri = Uri.parse("$url/api/connect/sendReminder");

    User user = await UserState.get();
    ProgressDialog pd = ProgressDialog(context: context);

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

    var response = await http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${user.token}"
            },
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return false;
    }

    /// Set options
    /// Max and msg required

    if (parsedResponse["status"]) {
      pd.close();

      return true;
      //all good
    } else {
      // error
      pd.close();
      return false;
    }
  }

  // get user's informations
  Future getProfile() async {
    User user = await UserState.get();
    var uri = Uri.parse("$url/api/profileDetails");
    var response = await http
        .get(uri, headers: {"Authorization": "Bearer ${user.token}"}).timeout(
            AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);
    print(parsedResponse);

    if (response.statusCode == 200) {
      return parsedResponse;
      // all good, details in parsedResponse
    }

    print(
        "[Api:getProfile] error: status code [${response.statusCode}]; body [${response.body}]");
    if (response.statusCode == 401) {
      pluhgSnackBar("So sorry", "You have to login again, session expired");
    }

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
    } else {
      pluhgSnackBar("So sorry", "Something went wrong");
    }

    print("[Api:getProfile] force user logout");
    await UserState.logout();

    return null;
  }

  //Update user's details API
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

    var response = await http
        .post(uri, headers: {"Authorization": "Bearer $token"}, body: body)
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
    }

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

    var response = await http
        .post(uri, headers: {"Authorization": "Bearer $token"}, body: body)
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return false;
    }

    if (parsedResponse["status"] == true) {
      // All okay
      Get.offAll(() => HomeView(index: 3.obs, isDeepLinkCodeExecute: false));
      pluhgSnackBar("Great", "You have changed your profile details");
      return false;
    } else {
      //ERROR
      pluhgSnackBar("So sorry", parsedResponse["message"].toString());
      // pr.hide();
      return false;
    }
  }

  // Update user's image
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

    var response = await request
        .send()
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      pluhgSnackBar('Sorry', '$TIME_OUT_EXCEPTION');
      throw '';
    });

    response.stream.transform(utf8.decoder).listen((var value) async {
      response.stream.transform(utf8.decoder);
    });

    if (response.statusCode == 200) {
      Future.delayed(Duration(microseconds: 10000), () {
        Get.offAll(() => HomeView(index: 3.obs, isDeepLinkCodeExecute: false));
        pluhgSnackBar("Great", "You have changed your picture");
      });

      return false;
    } else {
      pluhgSnackBar("So Sorry", response.reasonPhrase.toString());
      return false;
    }
  }

  // get notifications informations
  dynamic getNotificationSettings({
    required String token,
  }) async {
    var uri = Uri.parse("$url/api/notification/settings");
    // NotificationSettings settingz;
    var response = await http
        .get(uri, headers: {"Authorization": "Bearer $token"}).timeout(
            AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return null;
    }

    if (parsedResponse["status"] == true) {
      return parsedResponse;
      //All okay
    } else {
      return null;
      //ERROR
      // showPluhgDailog(context, "Error", parsedResponse["message"].toString());
    }
  }

  // update notification's settings
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

    var response = await http
        .post(uri,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            },
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      pluhgSnackBar("Great", "${parsedResponse['message']}");
      return false;
      //All okay
    } else {
      //ERROR

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
      response = await http
          .get(uri, headers: {"Authorization": "Bearer $token"}).timeout(
              AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
        return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
      });
    } catch (e) {
      print("API has Error");
      print("Error: ");
      print(e);
      return null;
    }

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return null;
    }

    if (parsedResponse["status"] == true) {
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

  // Get active connections
  Future<dynamic> getActiveConnections({
    required String token,
    required String contact,
  }) async {
    Uri uri = Uri.parse("$url/api/connect/activeConnections");
    var response;
    try {
      response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      ).timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
        return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
      });
    } catch (e) {
      print("[API:getActiveConnections] error: ${e.toString()}");
      return null;
    }

    var parsedResponse = jsonDecode(response.body);
    print("[API:getActiveConnections] response: ${parsedResponse.toString()}");

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return null;
    }

    if (parsedResponse["status"] == true) {
      return parsedResponse;
    }

    pluhgSnackBar("So Sorry", "${parsedResponse['message']}");
    return null;
  }

  // Get waiting connections
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
    }).timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    print('response ${response.body}');

    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return null;
    }

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

  // Accept or reject connection
  Future<bool> respondToConnectionRequest({
    required String contact,
    required BuildContext context,
    required String plugID,
    required bool isAccepting,
    required bool isRequester,
    required bool isContact,
    required String connectionID,
  }) async {
    print("[API:respondToConnectionRequest] contact: $contact");

    var uri = Uri.parse("$url/api/connect/acceptOrRejectConnection");
    User user = await UserState.get();

    ProgressDialog pd = ProgressDialog(context: context);
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

    print("[API:respondToConnectionRequest] send request: $body");
    var response = await http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${user.token}"
            },
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

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

    if (response.statusCode == 400) {
      pd.close();
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return false;
    }

    print(
        "[API:respondToConnectionRequest] response: ${parsedResponse.toString()}");

    if (parsedResponse["status"] == true) {
      pd.close();
      print(parsedResponse);
      showPluhgDailog2(
        context,
        "Success",
        "You have successfully ${isAccepting ? "accepted" : "rejected"} this  connection",
        onCLosed: () {
          print("[Dialogue:OnClose] go to HomeView [2]");
          Get.offAll(
              () => HomeView(index: 2.obs, isDeepLinkCodeExecute: false));
        },
      );

      //all good
      return false;
    } else {
      // error
      pd.close();
      pluhgSnackBar("So sorry", parsedResponse["message"]);
      return false;
    }
  }

  Future<bool> acceptConnectionRequest({
    required BuildContext context,
    required String connectionID,
  }) async {
    /* User user = await UserState.get();
    ProgressDialog pd = ProgressDialog(context: context);
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
      progressBgColor: Colors.transparent,
    );

    parsedResponse = await Future.delayed(Duration(seconds: 1)).then((value){
      pd.close();
      return true;
    });

    if (parsedResponse == true) {
      // "You have successfully ${isAccepting ? "accepted" : "rejected"} this  connection",
      showPluhgDailog2(
        context,
        "Success",
        'Meesage from db',
        onCLosed: () {
          print("[Dialogue:OnClose] go to HomeView [2]");
          Get.offAll(() => HomeView(index: 2.obs));
        },
      );

      return true;
    }

    // error
    pluhgSnackBar("So sorry", parsedResponse["message"]);
    return false;
    */

    var uri = Uri.parse("$url/api/connect/accept");
    User user = await UserState.get();
    print("[API:acceptConnectionRequest] user: ${user.toString()}");

    ProgressDialog pd = ProgressDialog(context: context);
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
      progressBgColor: Colors.transparent,
    );
    var body = {"connectionId": connectionID};

    print("[API:acceptConnectionRequest] send request: $body");
    var response = await http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${user.token}"
            },
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message": "$TIME_OUT_EXCEPTION"}', 400);
    });

    parsedResponse = jsonDecode(response.body);

    print(
        "[API:acceptConnectionRequest] response: ${parsedResponse.toString()}");

    pd.close();

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return false;
    }

    if (parsedResponse["status"] == true) {
      // "You have successfully ${isAccepting ? "accepted" : "rejected"} this  connection",
      showPluhgDailog2(
        context,
        "Success",
        parsedResponse["message"],
        onCLosed: () {
          print("[Dialogue:OnClose] go to HomeView [2]");
          Get.offAll(
              () => HomeView(index: 2.obs, isDeepLinkCodeExecute: false));
        },
      );

      return true;
    }

    // error
    pluhgSnackBar("So sorry", parsedResponse["message"]);
    return false;
  }

  Future<bool> declineConnectionRequest({
    required BuildContext context,
    required String connectionID,
    required String reason,
  }) async {
    var uri = Uri.parse("$url/api/connect/decline");
    User user = await UserState.get();
    print("[API:declineConnectionRequest] user: ${user.toString()}");

    ProgressDialog pd = ProgressDialog(context: context);
    var parsedResponse;
    pd.show(
      max: 100,
      msg: 'Please wait...',
      progressType: ProgressType.normal,
      progressBgColor: Colors.transparent,
    );
    var body = {"connectionId": connectionID};

    print("[API:declineConnectionRequest] send request: $body");
    var response = await http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${user.token}"
            },
            body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message" : "$TIME_OUT_EXCEPTION"}', 400);
    });

    parsedResponse = jsonDecode(response.body);

    print(
        "[API:declineConnectionRequest] response: ${parsedResponse.toString()}");

    pd.close();

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return false;
    }

    if (parsedResponse["status"] == true) {
      // "You have successfully ${isAccepting ? "accepted" : "rejected"} this  connection",
      showPluhgDailog2(
        context,
        "Success",
        parsedResponse["message"],
        onCLosed: () {
          print("[Dialogue:OnClose] go to HomeView [2]");
          Get.offAll(
              () => HomeView(index: 2.obs, isDeepLinkCodeExecute: false));
        },
      );

      return true;
    }

    // error
    pluhgSnackBar("So sorry", parsedResponse["message"]);
    return false;
  }

  //Close connection
  Future<bool> closeConnection(
      {required String connectionID,
      required BuildContext context,
      required String rating}) async {
    var uri = Uri.parse("$url/api/connect/closeConnection");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = await UserState.get();

    var parsedResponse;
    var response = await http
        .post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      },
      body: jsonEncode(
        {"connectionId": connectionID, "feedbackRating": rating},
      ),
    )
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message" : "$TIME_OUT_EXCEPTION"}', 400);
    });

    parsedResponse = jsonDecode(response.body);
    print("[closeConnection] response: $parsedResponse");

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
    }

    return parsedResponse["status"] == true;
  }

  //Check if user is a Pluhg user or not
  Future<List<PluhgContact>> checkPluhgUsers(
      {required List<PluhgContact> contacts}) async {
    var uri = Uri.parse("$url/api/checkIsPlughedUser");

    Map body = {
      "contacts": contacts.map((item) => item.toCleanedJson()).toList()
    };
    User user = await UserState.get();
    print("[checkPluhgUsers] send request: ${body.toString()}");
    var response = await http
        .post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      },
      body: jsonEncode(body),
    )
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message" : "$TIME_OUT_EXCEPTION"}', 400);
    });

    Map parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar("So Sorry", "${parsedResponse['message']}");
      return [];
    }
    print("[checkPluhgUsers] response: ${parsedResponse.toString()}");
    if (parsedResponse["status"] == false) {
      pluhgSnackBar("So Sorry", "${parsedResponse['message']}");
      return contacts;
    }

    List data = parsedResponse['data'];
    for (int i = 0; i < data.length; i++) {
      final user = data[i] as Map<String, dynamic>;
      final userPhoneNumber = formatPhoneNumber(user['phoneNumber'] as String);

      contacts.forEach((c) {
        final contactPhoneNumber = formatPhoneNumber(c.phoneNumber);

        if(contactPhoneNumber == userPhoneNumber || (user['emailAddress'] != null && c.emailAddress == (user['emailAddress'] as String).trim())){
          c.isPlughedUser = true;
        }
      });

      /*final registeredContacts = contacts.where((c) {
        final contactPhoneNumber = formatPhoneNumber(c.phoneNumber);
        return contactPhoneNumber == userPhoneNumber;
      });

      registeredContacts.forEach((rc) {
        rc.isPlughedUser = true;
      });*/
    }
    return contacts;
  }

  Future<bool> markAsRead(body) async {
    //to mark notification as read
    User user = await UserState.get();
    var uri = Uri.parse("$url/api/readNotification");

    print("[API:markAsRead] send request: $body");
    final headers = {
      'Authorization': "Bearer ${user.token}",
      'Content-type': 'application/json',
    };
    var response = await http
        .post(uri, headers: headers, body: jsonEncode(body))
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message" : "$TIME_OUT_EXCEPTION"}', 400);
    });
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    print("[API:markAsRead] response: ${responseBody.toString()}");

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', responseBody["message"].toString());
      return false;
    }

    return responseBody["status"] == true;
  }

  // get notification list
  Future<dynamic> getNotifications() async {
    User user = await UserState.get();
    var uri = Uri.parse("$url/api/getNotificationList");

    var response = await http
        .get(uri, headers: {"Authorization": "Bearer ${user.token}"}).timeout(
            AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('{"message" : "$TIME_OUT_EXCEPTION"}', 400);
    });
    var parsedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      return null;
    }

    print("[API:getNotifications] response: ${parsedResponse.toString()}");

    return NotificationResponse.fromJson(parsedResponse);
  }

  ///to get connection details used in dynamic for milestone one
  Future<RecommendationResponse> getConnectionDetails(
      {required String connectionID}) async {
    User user = await UserState.get();

    var uri = Uri.parse("$url/api/connect/getConnectionsDetails/$connectionID");
    var response = await http
        .get(uri, headers: {"Authorization": "Bearer ${user.token}"}).timeout(
            AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      return http.Response('"message" : "$TIME_OUT_EXCEPTION"', 400);
    });

    var parsedResponse = jsonDecode(response.body);
    print("[API:getNotifications] response: ${parsedResponse.toString()}");

    if (response.statusCode == 400) {
      pluhgSnackBar('Sorry', parsedResponse["message"].toString());
      throw '';
    }
    return RecommendationResponse.fromJson(parsedResponse);
  }

  // Upload file (document / image(s))
  Future<dynamic> uploadFile(
      String senderId, List<String> files, String type, String subType) async {
    User user = await UserState.get();
    Map<String, String> headers = {"Authorization": "Bearer ${user.token}"};
    print("[uploadFile] user token ${user.token}");

    List<http.MultipartFile> iterable = [];
    for (int i = 0; i < files.length; i++) {
      iterable.add(new http.MultipartFile.fromBytes(
          'files', await File(files[i]).readAsBytes(),
          filename: basename(files[i].split("/").last),
          contentType: MediaType(type, subType)));
    }

    final client = new HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    var request =
        http.MultipartRequest("POST", Uri.parse("$url/api/upload/upload-files"))
          ..files.addAll(iterable)
          ..headers.addAll(headers);

    //contentType: new MediaType('image', 'png'));

    var response = await request
        .send()
        .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
      pluhgSnackBar('Sorry', '$TIME_OUT_EXCEPTION');
      throw '';
    });

    var httpResponse = await http.Response.fromStream(response);

    print(httpResponse.body);
    var data = json.decode(httpResponse.body)["data"];

    return List<FileModel>.from(
        data.map((e) => FileModel.fromJson(e)).toList());
  }

  Future<int?> getNotificationCount() async {
    User user = await UserState.get();
    var uri = Uri.parse("$url/api/getNotificationCount");

    var response =
        await http.get(uri, headers: {"Authorization": "Bearer ${user.token}"});

    var parseResponse = jsonDecode(response.body);

    print(
        '[API:getNotificationCount] response : ${parseResponse['data']['unReadCount']}');

    return parseResponse['data']['unReadCount'];
  }
}
