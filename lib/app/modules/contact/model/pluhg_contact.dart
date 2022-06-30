import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';

class PluhgContact {
  String? id;
  Uint8List? photo;
  String? name;
  List<ContactData>? contacts;
  bool isSelected = false;
  bool isPlughedUser = false;
  String? imageUrl;

  PluhgContact({
    required this.id,
    required this.name,
    required this.contacts,
    this.imageUrl,
    this.photo,
    this.isSelected = false,
  });

  factory PluhgContact.empty() {
    return PluhgContact(id: "", name: "", contacts: [], isSelected: false);
  }

  PluhgContact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isPlughedUser = json['isPlughedUser'];
    photo = json['photo'];
    imageUrl = json['imageUrl'];
    if (json['contacts'] != null) {
      contacts = <ContactData>[];
      json['contacts'].forEach((v) {
        contacts!.add(new ContactData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contacts'] = this.contacts?.map((item) => item.toJson()).toList();
    data['isPlughedUser'] = this.isPlughedUser;
    return data;
  }

  factory PluhgContact.fromContact(Contact contact) {
    List<ContactData> tempList = [];
    tempList.addAll(contact.phones
        .map((e) => ContactData(
            image: contact.photo,
            name: contact.displayName,
            value: e.number,
            type: ContactType.phone))
        .toList());
    tempList.addAll(contact.emails
        .map((e) => ContactData(
            image: contact.photo,
            name: contact.displayName,
            value: e.address,
            type: ContactType.email))
        .toList());
    return PluhgContact(
        contacts: tempList,
        id: contact.id,
        name: contact.displayName,
        photo: contact.photo);
  }
}

enum ContactType {
  email,
  phone,
}

class ContactData {
  String? name;
  Uint8List? image;
  String? value;
  ContactType? type;
  bool? isSelected = false;
  bool? isPlughedUser = false;

  ContactData(
      {required this.name,
      this.image,
      required this.value,
      required this.type,
      this.isPlughedUser = false,
      this.isSelected = false});

  factory ContactData.empty() {
    return ContactData(
        name: "", value: "", type: ContactType.phone, isSelected: false);
  }

  ContactData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['contact'];
    isPlughedUser = json['isPlughedUser'];
    type = json['type'] == ContactType.email.name
        ? ContactType.email
        : ContactType.phone;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact'] = this.value;
    data['isPlughedUser'] = this.isPlughedUser;
    data['type'] = this.type?.name;
    return data;
  }
}
