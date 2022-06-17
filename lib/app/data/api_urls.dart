class ApplicationURLs {
  static const BASE_URL = "https://api.pluhg.com/api/";
  static const WS_URL = "ws://api.pluhg.com";

  // static const BASE_URL = "http://192.168.31.86:8000/api/";
  // static const WS_URL = "ws://192.168.31.86:8000";

  // static const BASE_URL = "http://192.168.43.65:8000/api/";
  // static const WS_URL = "ws://192.168.43.65:8000";

  //Authentication
  static const API_LOGIN = BASE_URL + "login";
  static const API_VERIFY_OTP = BASE_URL + "verifyOTP";
  static const API_CREATE_PROFILE = BASE_URL + "createProfile";
  static const API_SEND_SUPPORT_EMAIL = BASE_URL + "sendSupportEmail";
  static const API_CONNECT_PEOPLE = BASE_URL + "connect/people";
  static const API_SEND_REMINDER = BASE_URL + "connect/sendReminder";
  static const API_GET_PROFILE = BASE_URL + "profileDetails";
  static const API_UPDATE_PROFILE = BASE_URL + "updateProfileDetails";
  static const API_GET_NOTIFICATION_SETTINGS =
      BASE_URL + "notification/settings";
  static const API_GET_RECOMMENDED_CONNECTIONS =
      BASE_URL + "connect/whoIconnected";
  static const API_GET_ACTIVE_CONNECTIONS =
      BASE_URL + "connect/activeConnections";
  static const API_GET_WAITING_CONNECTIONS =
      BASE_URL + "connect/waitingConnections";
  static const API_GET_NOTIFICATIONS = BASE_URL + "getNotificationList";
  static const API_READ_NOTIFICATIONS = BASE_URL + "readNotification";
  static const API_GET_NOTIFICATION_COUNT = BASE_URL + "getNotificationCount";
  static const API_GET_RECOMMENDED_CONNECTION_DETAILS =
      BASE_URL + "connect/getRecommendedConnectionsDetails/";
  static const API_GET_WAITING_CONNECTION_DETAILS =
      BASE_URL + "connect/getWaitingConnectionDetails/";
  static const API_ACCEPT_CONNECTION = BASE_URL + "connect/accept";
  static const API_DECLINE_CONNECTION = BASE_URL + "connect/decline";
  static const API_CLOSE_CONNECTION = BASE_URL + "connect/closeConnection";
  static const API_UPDATE_NOTFICATION_SETTINGS =
      BASE_URL + "notification/settings/update";
  static const API_CHECK_PLUHG_USERS = BASE_URL + "checkIsPlughedUser";
}
