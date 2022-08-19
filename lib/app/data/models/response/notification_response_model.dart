import 'connection_response_model.dart';

class NotificationResponseModel {
  int? status;
  String? sId;
  UserId? userId;
  NotificationMsg? notificationMsg;
  String? type;
  String? createdAt;
  String? updatedAt;
  ConnectionResponseModel? connectionResponseModel;

  NotificationResponseModel(
      {this.status,
      this.sId,
      this.userId,
      this.notificationMsg,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.connectionResponseModel});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sId = json['_id'];
    userId =
        json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    notificationMsg = json['notificationMsg'] != null
        ? new NotificationMsg.fromJson(json['notificationMsg'])
        : null;
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    connectionResponseModel = json['connectionData'] != null
        ? new ConnectionResponseModel.fromJson(json['connectionData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    if (this.notificationMsg != null) {
      data['notificationMsg'] = this.notificationMsg!.toJson();
    }
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['connectionData'] = this.connectionResponseModel!.toJson();
    return data;
  }
}

class UserId {
  String? emailAddress;
  String? phoneNumber;
  Null? lastLogin;
  int? numberOfConnections;
  String? name;
  String? userName;
  String? address;
  String? profileImage;
  String? deviceToken;
  String? review;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserId(
      {this.emailAddress,
      this.phoneNumber,
      this.lastLogin,
      this.numberOfConnections,
      this.name,
      this.userName,
      this.address,
      this.profileImage,
      this.deviceToken,
      this.review,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  UserId.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    lastLogin = json['lastLogin'];
    numberOfConnections = json['numberOfConnections'];
    name = json['name'];
    userName = json['userName'];
    address = json['address'];
    profileImage = json['profileImage'];
    deviceToken = json['deviceToken'];
    review = json['review'];
    sId = json['_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailAddress'] = this.emailAddress;
    data['phoneNumber'] = this.phoneNumber;
    data['lastLogin'] = this.lastLogin;
    data['numberOfConnections'] = this.numberOfConnections;
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['address'] = this.address;
    data['profileImage'] = this.profileImage;
    data['deviceToken'] = this.deviceToken;
    data['review'] = this.review;
    data['_id'] = this.sId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class NotificationMsg {
  String? priority;
  String? sound;
  String? title;
  String? body;
  bool? contentAvailable;
  int? badge;
  String? type;

  NotificationMsg(
      {this.priority,
      this.sound,
      this.title,
      this.body,
      this.contentAvailable,
      this.badge,
      this.type});

  NotificationMsg.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    sound = json['sound'];
    title = json['title'];
    body = json['body'];
    contentAvailable = json['content_available'];
    badge = json['badge'];
    type = json['type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority'] = this.priority;
    data['sound'] = this.sound;
    data['title'] = this.title;
    data['body'] = this.body;
    data['content_available'] = this.contentAvailable;
    data['badge'] = this.badge;
    data['type'] = this.type.toString();
    return data;
  }
}

class NotificationListModel {
  List<NotificationResponseModel> values = [];

  NotificationListModel() {
    values = [];
  }

  NotificationListModel.fromJson(var jsonObject) {
    if(jsonObject !=null){
      for (var area in jsonObject) {
        NotificationResponseModel model =
        NotificationResponseModel.fromJson(area);
        this.values.add(model);
      }
    }
  }
}
