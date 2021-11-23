// To parse this JSON data, do
//
//     final notificationSettings = notificationSettingsFromJson(jsonString);

import 'dart:convert';

NotificationSettings notificationSettingsFromJson(String str) =>
    NotificationSettings.fromJson(json.decode(str));

String notificationSettingsToJson(NotificationSettings data) =>
    json.encode(data.toJson());

class NotificationSettings {
  NotificationSettings({
    required this.data,
    required this.hasError,
    required this.message,
    required this.totalCount,
  });

  Data data;
  bool hasError;
  String message;
  int totalCount;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        data: Data.fromJson(json["data"]),
        hasError: json["hasError"],
        message: json["message"],
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "hasError": hasError,
        "message": message,
        "totalCount": totalCount,
      };
}

class Data {
  Data({
    required this.userId,
    required this.pushNotification,
    required this.emailNotification,
    required this.textNotification,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String userId;
  bool pushNotification;
  bool emailNotification;
  bool textNotification;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        pushNotification: json["pushNotification"],
        emailNotification: json["emailNotification"],
        textNotification: json["textNotification"],
        id: json["_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "pushNotification": pushNotification,
        "emailNotification": emailNotification,
        "textNotification": textNotification,
        "_id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}
