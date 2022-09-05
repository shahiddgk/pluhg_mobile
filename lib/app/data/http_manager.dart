import 'package:plug/app/data/models/general_response_model.dart';
import 'package:plug/app/data/models/request/check_contact_request_model.dart';
import 'package:plug/app/data/models/request/connect_people_request_model.dart';
import 'package:plug/app/data/models/request/connection_request_model.dart';
import 'package:plug/app/data/models/request/login_request_model.dart';
import 'package:plug/app/data/models/request/notification_request_model.dart';
import 'package:plug/app/data/models/request/notification_settings_request_model.dart';
import 'package:plug/app/data/models/request/profile_create_request_model.dart';
import 'package:plug/app/data/models/request/reminder_request_model.dart';
import 'package:plug/app/data/models/request/support_request_model.dart';
import 'package:plug/app/data/models/request/update_profile_request.dart';
import 'package:plug/app/data/models/request/verify_otp_request_model.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/data/models/response/contact_response_model.dart';
import 'package:plug/app/data/models/response/notification_response_model.dart';
import 'package:plug/app/data/models/response/notification_settings_model.dart';
import 'package:plug/app/data/models/response/verify_otp_response_model.dart';
import 'package:plug/app/data/response_handler.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';

import 'api_urls.dart';

class HTTPManager {
  ResponseHandler _handler = ResponseHandler();

  Future<GeneralResponseModel> loginUser(LoginRequestModel loginRequest) async {
    final url = ApplicationURLs.API_LOGIN;
    final GeneralResponseModel response =
        await _handler.post(url, loginRequest.toJson());
    return response;
  }

  Future<VerifyOtpResponseModel> verifyOtp(
      VerifyOtpRequestModel verifyOtpRequestModel) async {
    final url = ApplicationURLs.API_VERIFY_OTP;
    final GeneralResponseModel response =
        await _handler.post(url, verifyOtpRequestModel.toJson());
    VerifyOtpResponseModel sessionUserModel =
        VerifyOtpResponseModel.fromJson(response.data);
    return sessionUserModel;
  }

  Future<VerifyOtpResponseModel> createProfile(
      CreateProfileRequestModel createProfileRequestModel) async {
    final url = ApplicationURLs.API_CREATE_PROFILE;

    final GeneralResponseModel response =
        await _handler.post(url, createProfileRequestModel.toJson());
    VerifyOtpResponseModel sessionUserModel =
        VerifyOtpResponseModel.fromJson(response.data);
    return sessionUserModel;
  }

  Future<GeneralResponseModel> sendSupportEmail(
      SupportRequestModel supportRequestModel) async {
    final url = ApplicationURLs.API_CREATE_PROFILE;
    final GeneralResponseModel response =
        await _handler.post(url, supportRequestModel.toJson());
    return response;
  }

  Future<GeneralResponseModel> connectTwoPeople(
      ConnectPeopleRequestModel connectionRequestModel) async {
    final url = ApplicationURLs.API_CONNECT_PEOPLE;
    print("CONNECT 2 PEOPLE");
    print(url);
    final GeneralResponseModel response =
        await _handler.post(url, connectionRequestModel.toJson());
    return response;
  }

  Future<GeneralResponseModel> sendReminder(
      ReminderRequestModel reminderRequestModel) async {
    final url = ApplicationURLs.API_SEND_REMINDER;
    final GeneralResponseModel response =
        await _handler.post(url, reminderRequestModel.toJson());
    return response;
  }

  Future<UserData> getProfileDetails() async {
    final url = ApplicationURLs.API_GET_PROFILE;
    final GeneralResponseModel response = await _handler.get(url);
    UserData userData = UserData.fromJson(response.data);
    return userData;
  }

  Future<GeneralResponseModel> updateProfileDetails(var imageFile,
      UpdateProfileRequestModel updateProfileRequestModel) async {
    final url = ApplicationURLs.API_UPDATE_PROFILE;
    print(url);
    final GeneralResponseModel response = await _handler.postWithImage(
        url, updateProfileRequestModel.toJson(), imageFile);
    return response;
  }

  Future<NotificationSettingsModel> getNotificationSettings() async {
    final url = ApplicationURLs.API_GET_NOTIFICATION_SETTINGS;
    final GeneralResponseModel response = await _handler.get(url);
    NotificationSettingsModel notificationSettingsModel =
        NotificationSettingsModel.fromJson(response.data);
    return notificationSettingsModel;
  }

  Future<ConnectionListModel> getRecommendedConnections() async {
    final url = ApplicationURLs.API_GET_RECOMMENDED_CONNECTIONS;
    final GeneralResponseModel response = await _handler.get(url);
    ConnectionListModel connectionListModel =
        ConnectionListModel.fromJson(response.data);
    return connectionListModel;
  }

  Future<ConnectionListModel> getActiveConnections() async {
    final url = ApplicationURLs.API_GET_ACTIVE_CONNECTIONS;
    final GeneralResponseModel response = await _handler.get(url);
    ConnectionListModel connectionListModel =
        ConnectionListModel.fromJson(response.data);
    return connectionListModel;
  }

  Future<ConnectionListModel> getWaitingConnections() async {
    final url = ApplicationURLs.API_GET_WAITING_CONNECTIONS;
    print("getWaitingConnections");
    print(url);
    final GeneralResponseModel response = await _handler.get(url);
    ConnectionListModel connectionListModel =
        ConnectionListModel.fromJson(response.data);
    return connectionListModel;
  }

  Future<NotificationListModel> getNotifications() async {
    final url = ApplicationURLs.API_GET_NOTIFICATIONS;
    print(url);
    final GeneralResponseModel response = await _handler.get(url);
    NotificationListModel notificationListModel =
        NotificationListModel.fromJson(response.data);
    return notificationListModel;
  }

  Future<NotificationListModel> readNotifications(
      NotificationRequestModel notificationRequestModel) async {
    final url = ApplicationURLs.API_READ_NOTIFICATIONS;
    print(url);
    final GeneralResponseModel response =
        await _handler.post(url, notificationRequestModel.toJson());
    NotificationListModel notificationListModel =
        NotificationListModel.fromJson(response.data);
    return notificationListModel;
  }

  Future<NotificationListModel> deleteNotifications(
      NotificationRequestModel notificationRequestModel) async {
    final url = ApplicationURLs.API_DELETE_NOTIFICATIONS;
    final GeneralResponseModel response =
        await _handler.post(url, notificationRequestModel.toJson());
    NotificationListModel notificationListModel =
        NotificationListModel.fromJson(response.data);
    return notificationListModel;
  }

  Future<int> getNotificationCount() async {
    final url = ApplicationURLs.API_GET_NOTIFICATION_COUNT;
    print("Notification Count");
    print(url);
    final GeneralResponseModel response = await _handler.get(url);
    return response.data["unReadCount"];
  }

  Future<ConnectionResponseModel> getConnectionDetails(
      {required String path, required String connectionId}) async {
    print("getConnectionDetails");
    print(path);
    print(connectionId);
    final url = path;
    final GeneralResponseModel response =
        await _handler.get('$url$connectionId');
    ConnectionResponseModel connectionResponseModel =
        ConnectionResponseModel.fromJson(response.data);
    return connectionResponseModel;
  }

  Future<ConnectionResponseModel> acceptConnection(
      ConnectionRequestModel connectionRequestModel) async {
    final url = ApplicationURLs.API_ACCEPT_CONNECTION;
    final GeneralResponseModel response =
        await _handler.post(url, connectionRequestModel.toJson());
    ConnectionResponseModel connectionResponseModel =
        ConnectionResponseModel.fromJson(response.data);
    return connectionResponseModel;
  }

  Future<GeneralResponseModel> declineConnection(
      ConnectionRequestModel connectionRequestModel) async {
    final url = ApplicationURLs.API_DECLINE_CONNECTION;
    final GeneralResponseModel response =
        await _handler.post(url, connectionRequestModel.toJson());
    return response;
  }

  Future<GeneralResponseModel> closeConnection(
      ConnectionRequestModel connectionRequestModel) async {
    final url = ApplicationURLs.API_CLOSE_CONNECTION;
    final GeneralResponseModel response =
        await _handler.post(url, connectionRequestModel.toJson());
    return response;
  }

  Future<GeneralResponseModel> updateNotificationSettings(
      NotificationSettingsRequestModel notificationSettingsRequestModel) async {
    final url = ApplicationURLs.API_UPDATE_NOTFICATION_SETTINGS;
    final GeneralResponseModel response =
        await _handler.post(url, notificationSettingsRequestModel.toJson());
    return response;
  }

  Future<List<PluhgContact>> checkIfPluhgUsers(
      CheckContactRequestModel checkContactRequestModel) async {
    final url = ApplicationURLs.API_CHECK_PLUHG_USERS;
    print("PLUHG USER CHECKING");
    print(url);
    print(checkContactRequestModel.pluhgContacts?.length);
    final GeneralResponseModel response =
        await _handler.post(url, checkContactRequestModel.toJson());
    ContactResponseModel contactResponseModel =
        ContactResponseModel.fromJson(response.data);
    return contactResponseModel.values;
  }
}
