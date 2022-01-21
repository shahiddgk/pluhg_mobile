class NotificationResponse {
  NotificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  NotificationResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.status,
    required this.id,
    required this.userId,
    required this.notificationMsg,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int status;
  late final String id;
  late final UserId userId;
  late final NotificationMsg notificationMsg;
  late final String type;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    status =  json['status']==null?0:json['status'];
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    notificationMsg = NotificationMsg.fromJson(json['notificationMsg']);
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['notificationMsg'] = notificationMsg.toJson();
    _data['type'] = type;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class UserId {
  UserId({
    required this.emailAddress,
    required this.phoneNumber,
  //  required this.lastLogin,
    required this.numberOfConnections,
    this.name,
    required this.userName,
    this.address,
    required this.profileImage,
    this.review,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.deviceToken,
  });
  late final String emailAddress;
  late final String phoneNumber;
 // late final String lastLogin;
  late final int numberOfConnections;
  late final Null name;
  late final String userName;
  late final Null address;
  late final String profileImage;
  late final Null review;
  late final String id;
  late final String createdAt;
  late final String updatedAt;
  late final int v;
  late final Null deviceToken;

  UserId.fromJson(Map<String, dynamic> json){
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
   // lastLogin = json['lastLogin'];
    numberOfConnections = json['numberOfConnections'];
    name = null;
    userName = json['userName'];
    address = null;
    profileImage = json['profileImage'];
    review = null;
    id = json['_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    v = json['__v'];
    deviceToken = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['emailAddress'] = emailAddress;
    _data['phoneNumber'] = phoneNumber;
  //  _data['lastLogin'] = lastLogin;
    _data['numberOfConnections'] = numberOfConnections;
    _data['name'] = name;
    _data['userName'] = userName;
    _data['address'] = address;
    _data['profileImage'] = profileImage;
    _data['review'] = review;
    _data['_id'] = id;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['__v'] = v;
    _data['deviceToken'] = deviceToken;
    return _data;
  }
}

class NotificationMsg {
  NotificationMsg({
    required this.title,
    required this.body,
    required this.contentAvailable,
    required this.priority,
    required this.sound,
    required this.badge,
  });
  late final String title;
  late final String body;
  late final bool contentAvailable;
  late final String priority;
  late final String sound;
  late final int badge;

  NotificationMsg.fromJson(Map<String, dynamic> json){
    title = json['title'];
    body = json['body'];
    contentAvailable = json['content_available'];
    priority = json['priority'];
    sound = json['sound'];
    badge = json['badge'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['body'] = body;
    _data['content_available'] = contentAvailable;
    _data['priority'] = priority;
    _data['sound'] = sound;
    _data['badge'] = badge;
    return _data;
  }
}