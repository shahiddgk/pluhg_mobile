class RecommendationResponse {
  RecommendationResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  final bool status;
  final String message;
  final ResponseData data;

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      status: json['status'],
      message: json['message'],
      data: ResponseData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class ResponseData {
  ResponseData({
    required this.requester,
    required this.contact,
    required this.isRequesterAccepted,
    required this.isContactAccepted,
    required this.isPending,
    required this.rejectReason,
    required this.requesterMessage,
    required this.contactMessage,
    required this.both,
    required this.closeConnection,
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final Requester requester;
  final Contact contact;
  final bool isRequesterAccepted;
  final bool isContactAccepted;
  final bool isPending;
  final String rejectReason;
  final String requesterMessage;
  final String contactMessage;
  final String both;
  final bool closeConnection;
  final String id;
  final UserId userId;
  final String createdAt;
  final String updatedAt;
  final int v;

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return new ResponseData(
      requester: Requester.fromJson(json['requester']),
      contact: Contact.fromJson(json['contact']),
      isRequesterAccepted: json['isRequesterAccepted'],
      isContactAccepted: json['isContactAccepted'],
      isPending: json['isPending'],
      rejectReason: json['rejectReason'],
      requesterMessage: json['requesterMessage'],
      contactMessage: json['contactMessage'],
      both: json['both'] ?? "",
      closeConnection: json['closeConnection'],
      id: json['_id'],
      userId: UserId.fromJson(json['userId']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['requester'] = requester.toJson();
    _data['contact'] = contact.toJson();
    _data['isRequesterAccepted'] = isRequesterAccepted;
    _data['isContactAccepted'] = isContactAccepted;
    _data['isPending'] = isPending;
    _data['rejectReason'] = rejectReason;
    _data['requesterMessage'] = requesterMessage;
    _data['contactMessage'] = contactMessage;
    _data['both'] = both;
    _data['closeConnection'] = closeConnection;
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['__v'] = v;
    return _data;
  }
}

class Requester {
  Requester({
    required this.name,
    required this.contact,
    required this.contactType,
    required this.message,
    required this.refId,
  });
  final String name;
  final String contact;
  final String contactType;
  final String message;
  final RefId refId;

  factory Requester.fromJson(Map<String, dynamic> json) {
    return new Requester(
      name: json['name'],
      contact: json['contact'],
      contactType: json['contactType'],
      message: json['message'],
      refId: RefId.fromJson(json['refId']),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['contact'] = contact;
    _data['contactType'] = contactType;
    _data['message'] = message;
    _data['refId'] = refId.toJson();
    return _data;
  }
}

class RefId {
  RefId({
    required this.numberOfConnections,
    required this.userName,
    required this.name,
    required this.profileImage,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
  final int numberOfConnections;
  final String name;
  final String userName;
  final String profileImage;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  factory RefId.fromJson(Map<String, dynamic> json) {
    return RefId(
      numberOfConnections: json['numberOfConnections'],
      name: json['name'] ?? "",
      userName: json['userName'] ?? "",
      profileImage: json['profileImage'],
      id: json['_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['numberOfConnections'] = numberOfConnections;
    _data['userName'] = userName;
    _data['name'] = name;
    _data['profileImage'] = profileImage;
    _data['_id'] = id;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['__v'] = v;
    return _data;
  }
}

class Contact {
  Contact({
    required this.name,
    required this.contact,
    required this.contactType,
    required this.message,
    required this.refId,
  });
  String? name;
  String? contact;
  final String contactType;
  final String message;
  final RefId refId;

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] ?? "",
      contact: json['contact'],
      contactType: json['contactType'],
      message: json['message'],
      refId: RefId.fromJson(json['refId']),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['contact'] = contact;
    _data['contactType'] = contactType;
    _data['message'] = message;
    _data['refId'] = refId.toJson();
    return _data;
  }
}

class UserId {
  UserId({
    required this.emailAddress,
    required this.phoneNumber,
    required this.numberOfConnections,
    required this.userName,
    required this.profileImage,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
  final String emailAddress;
  final String phoneNumber;
  final int numberOfConnections;
  final String userName;
  final String profileImage;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      emailAddress: json['emailAddress'],
      phoneNumber: json['phoneNumber'],
      numberOfConnections: json['numberOfConnections'],
      userName: json['userName'],
      profileImage: json['profileImage'],
      id: json['_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['emailAddress'] = emailAddress;
    _data['phoneNumber'] = phoneNumber;
    _data['numberOfConnections'] = numberOfConnections;
    _data['userName'] = userName;
    _data['profileImage'] = profileImage;
    _data['_id'] = id;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['__v'] = v;
    return _data;
  }
}
