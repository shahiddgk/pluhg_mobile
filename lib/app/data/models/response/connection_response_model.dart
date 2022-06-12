class ConnectionResponseModel {
  Requester? requester;
  Requester? contact;
  bool? isRequesterAccepted;
  bool? isContactAccepted;
  bool? isPending;
  String? rejectReason;
  String? requesterMessage;
  String? contactMessage;
  String? requesterPreMessage;
  String? contactPreMessage;
  String? both;
  bool? closeConnection;
  Null? feedbackRating;
  String? sId;
  RefId? userId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ConnectionResponseModel(
      {this.requester,
      this.contact,
      this.isRequesterAccepted,
      this.isContactAccepted,
      this.isPending,
      this.rejectReason,
      this.requesterMessage,
      this.requesterPreMessage,
      this.contactMessage,
      this.contactPreMessage,
      this.both,
      this.closeConnection,
      this.feedbackRating,
      this.sId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ConnectionResponseModel.fromJson(Map<String, dynamic> json) {
    requester = json['requester'] != null
        ? new Requester.fromJson(json['requester'])
        : null;
    contact = json['contact'] != null
        ? new Requester.fromJson(json['contact'])
        : null;
    isRequesterAccepted = json['isRequesterAccepted'];
    isContactAccepted = json['isContactAccepted'];
    isPending = json['isPending'];
    rejectReason = json['rejectReason'];
    requesterMessage = json['requesterMessage'];
    contactMessage = json['contactMessage'];
    requesterPreMessage = json['requesterPreMessage'];
    contactPreMessage = json['contactPreMessage'];
    both = json['both'];
    closeConnection = json['closeConnection'];
    feedbackRating = json['feedbackRating'];
    sId = json['_id'];
    userId = json['userId'] != null ? new RefId.fromJson(json['userId']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requester != null) {
      data['requester'] = this.requester!.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
    }
    data['isRequesterAccepted'] = this.isRequesterAccepted;
    data['isContactAccepted'] = this.isContactAccepted;
    data['isPending'] = this.isPending;
    data['rejectReason'] = this.rejectReason;
    data['requesterMessage'] = this.requesterMessage;
    data['contactMessage'] = this.contactMessage;
    data['requesterPreMessage'] = this.requesterPreMessage;
    data['contactPreMessage'] = this.contactPreMessage;
    data['both'] = this.both;
    data['closeConnection'] = this.closeConnection;
    data['feedbackRating'] = this.feedbackRating;
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Requester {
  String? contact;
  String? contactType;
  String? message;
  String? name;
  RefId? refId;

  Requester({this.contact, this.contactType, this.message, this.refId});

  Requester.fromJson(Map<String, dynamic> json) {
    contact = json['contact'];
    contactType = json['contactType'];
    message = json['message'];
    name = json['name'];
    refId = json['refId'] != null ? new RefId.fromJson(json['refId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    data['contactType'] = this.contactType;
    data['message'] = this.message;
    data['name'] = this.name;
    if (this.refId != null) {
      data['refId'] = this.refId!.toJson();
    }
    return data;
  }
}

class RefId {
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

  RefId(
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

  RefId.fromJson(Map<String, dynamic> json) {
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

class ConnectionListModel {
  List<ConnectionResponseModel> values = [];

  ConnectionListModel() {
    values = [];
  }

  ConnectionListModel.fromJson(var jsonObject) {
    if (jsonObject != null) {
      for (var area in jsonObject) {
        ConnectionResponseModel model = ConnectionResponseModel.fromJson(area);
        this.values.add(model);
      }
    }
  }
}
