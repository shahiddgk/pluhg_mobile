class Snapshot {
  Snapshot({
    required this.data,
    required this.hasError,
    required this.message,
    required this.totalCount,
  });

  List<Datum>? data;
  bool hasError;
  String message;
  int totalCount;

  factory Snapshot.fromJson(Map<String, dynamic> json) => Snapshot(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasError: json["hasError"] == null ? null : json["hasError"],
        message: json["message"] == null ? null : json["message"],
        totalCount: json["totalCount"] == null ? null : json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "hasError": hasError == null ? null : hasError,
        "message": message == null ? null : message,
        "totalCount": totalCount == null ? null : totalCount,
      };
}

class Datum {
  Datum({
    required this.requester,
    required this.contact,
    required this.isRequesterAccepted,
    required this.isContactAccepted,
    required this.isPending,
    required this.rejectReason,
    required this.requeterMessage,
    required this.contactMessage,
    required this.closeConnection,
    required this.feedbackRating,
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  Requester? requester;
  Contact? contact;
  bool isRequesterAccepted;
  bool isContactAccepted;
  bool isPending;
  String rejectReason;
  String requeterMessage;
  String contactMessage;
  bool closeConnection;
  dynamic feedbackRating;
  String id;
  Id? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        requester: json["requester"] == null
            ? null
            : Requester.fromJson(json["requester"]),
        contact:
            json["contact"] == null ? null : Contact.fromJson(json["contact"]),
        isRequesterAccepted: json["isRequesterAccepted"] == null
            ? null
            : json["isRequesterAccepted"],
        isContactAccepted: json["isContactAccepted"] == null
            ? null
            : json["isContactAccepted"],
        isPending: json["isPending"] == null ? null : json["isPending"],
        rejectReason:
            json["rejectReason"] == null ? null : json["rejectReason"],
        requeterMessage:
            json["requeterMessage"] == null ? null : json["requeterMessage"],
        contactMessage:
            json["contactMessage"] == null ? null : json["contactMessage"],
        closeConnection:
            json["closeConnection"] == null ? null : json["closeConnection"],
        feedbackRating: json["feedbackRating"],
        id: json["_id"] == null ? null : json["_id"],
        userId: json["userId"] == null ? null : Id.fromJson(json["userId"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        v: json["_v"] == null ? null : json["_v"],
      );

  Map<String, dynamic> toJson() => {
        "requester": requester == null ? null : requester!.toJson(),
        "contact": contact == null ? null : contact!.toJson(),
        "isRequesterAccepted":
            isRequesterAccepted == null ? null : isRequesterAccepted,
        "isContactAccepted":
            isContactAccepted == null ? null : isContactAccepted,
        "isPending": isPending == null ? null : isPending,
        "rejectReason": rejectReason == null ? null : rejectReason,
        "requeterMessage": requeterMessage == null ? null : requeterMessage,
        "contactMessage": contactMessage == null ? null : contactMessage,
        "closeConnection": closeConnection == null ? null : closeConnection,
        "feedbackRating": feedbackRating,
        "_id": id == null ? null : id,
        "userId": userId == null ? null : userId!.toJson(),
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v == null ? null : v,
      };
}

class Contact {
  Contact({
    required this.phoneNumber,
    required this.name,
    required this.refId,
    required this.message,
    required this.profileImage,
  });

  String phoneNumber;
  String name;
  Id? refId;
  String message;
  dynamic profileImage;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        name: json["name"] == null ? null : json["name"],
        refId: json["refId"] == null ? null : Id.fromJson(json["refId"]),
        message: json["message"] == null ? null : json["message"],
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "name": name == null ? null : name,
        "refId": refId == null ? null : refId!.toJson(),
        "message": message == null ? null : message,
        "profileImage": profileImage,
      };
}

class Id {
  Id({
    required this.lastLogin,
    required this.numberOfConnections,
    required this.name,
    required this.userName,
    required this.address,
    required this.profileImage,
    required this.id,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.emailAddress,
    required this.deviceToken,
  });

  DateTime? lastLogin;
  int numberOfConnections;
  String name;
  String userName;
  dynamic address;
  String profileImage;
  String id;
  String phoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int v;
  String emailAddress;
  String deviceToken;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        lastLogin: json["lastLogin"] == null
            ? null
            : DateTime.parse(json["lastLogin"]),
        numberOfConnections: json["numberOfConnections"] == null
            ? null
            : json["numberOfConnections"],
        name: json["name"] == null ? null : json["name"],
        userName: json["userName"] == null ? null : json["userName"],
        address: json["address"],
        profileImage:
            json["profileImage"] == null ? null : json["profileImage"],
        id: json["_id"] == null ? null : json["_id"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        v: json["_v"] == null ? null : json["_v"],
        emailAddress:
            json["emailAddress"] == null ? null : json["emailAddress"],
        deviceToken: json["deviceToken"] == null ? null : json["deviceToken"],
      );

  Map<String, dynamic> toJson() => {
        "lastLogin": lastLogin == null ? null : lastLogin!.toIso8601String(),
        "numberOfConnections":
            numberOfConnections == null ? null : numberOfConnections,
        "name": name == null ? null : name,
        "userName": userName == null ? null : userName,
        "address": address,
        "profileImage": profileImage == null ? null : profileImage,
        "_id": id == null ? null : id,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v == null ? null : v,
        "emailAddress": emailAddress == null ? null : emailAddress,
        "deviceToken": deviceToken == null ? null : deviceToken,
      };
}

class Requester {
  Requester({
    required this.emailAddress,
    required this.name,
    required this.refId,
    required this.message,
    required this.profileImage,
    required this.phoneNumber,
  });

  String emailAddress;
  String name;
  Id? refId;
  String message;
  dynamic profileImage;
  String phoneNumber;

  factory Requester.fromJson(Map<String, dynamic> json) => Requester(
        emailAddress:
            json["emailAddress"] == null ? null : json["emailAddress"],
        name: json["name"] == null ? null : json["name"],
        refId: json["refId"] == null ? null : Id.fromJson(json["refId"]),
        message: json["message"] == null ? null : json["message"],
        profileImage: json["profileImage"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "emailAddress": emailAddress == null ? null : emailAddress,
        "name": name == null ? null : name,
        "refId": refId == null ? null : refId!.toJson(),
        "message": message == null ? null : message,
        "profileImage": profileImage,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
      };
}
