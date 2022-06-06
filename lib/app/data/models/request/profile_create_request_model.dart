import 'package:plug/app/services/UserState.dart';

class CreateProfileRequestModel {
  String? contact;
  String? userName;
  String? contactType;

  CreateProfileRequestModel({this.userName, this.contact, this.contactType});

  CreateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    if (contactType == User.PHONE_CONTACT_TYPE) {
      contact = json['phoneNumber'];
    } else {
      contact = json['emailAddress'];
    }
    userName = json['userName'];
    contactType = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (contactType == User.PHONE_CONTACT_TYPE) {
      data['phoneNumber'] = this.contact;
    } else {
      data['emailAddress'] = this.contact;
    }
    data['userName'] = this.userName;
    return data;
  }
}
