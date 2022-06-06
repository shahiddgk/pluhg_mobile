class VerifyOtpResponseModel {
  RemoteUser? user;
  String? token;

  VerifyOtpResponseModel({this.user, this.token});

  VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new RemoteUser.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class RemoteUser {
  UserData? data;
  bool? isRegistered;

  RemoteUser({this.data, this.isRegistered});

  RemoteUser.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    isRegistered = json['isRegistered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isRegistered'] = this.isRegistered;
    return data;
  }
}

class UserData {
  String? emailAddress;
  String? phoneNumber;
  String? lastLogin;
  int? numberOfConnections;
  String? name;
  String? userName;
  String? address;
  String? profileImage;
  String? review;
  String? sId;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserData(
      {this.emailAddress,
        this.phoneNumber,
        this.lastLogin,
        this.numberOfConnections,
        this.name,
        this.userName,
        this.address,
        this.profileImage,
        this.review,
        this.sId,
        this.deviceToken,
        this.createdAt,
        this.updatedAt,
        this.iV});

  UserData.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    lastLogin = json['lastLogin'];
    numberOfConnections = json['numberOfConnections'];
    name = json['name'];
    userName = json['userName'];
    address = json['address'];
    profileImage = json['profileImage'];
    review = json['review'];
    sId = json['_id'];
    deviceToken = json['deviceToken'];
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
    data['review'] = this.review;
    data['_id'] = this.sId;
    data['deviceToken'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}