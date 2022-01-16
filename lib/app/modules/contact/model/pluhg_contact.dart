import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';

class PluhgContact {
  bool isPlughedUser = false;
  String? id;
  Uint8List? photo;
  String name, phoneNumber, emailAddress;

  PluhgContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.photo,
    required this.emailAddress,
    required this.isPlughedUser,
  });

  PluhgContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    Uint8List? photo,
    String? emailAddress,
    bool? isPlughedUser,
  }) {
    return PluhgContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      emailAddress: emailAddress ?? this.emailAddress,
      isPlughedUser: isPlughedUser ?? this.isPlughedUser,
    );
  }

  @override
  String toString() {
    return "{id: ${this.id}, name: ${this.name}, emailAddress: ${this.emailAddress}, isPlughedUser: ${this.isPlughedUser}, phoneNumber: ${this.phoneNumber}, photo: ${this.photo}}";
  }

  Map toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "emailAddress": this.emailAddress,
      "isPlughedUser": this.isPlughedUser,
      "phoneNumber": this.phoneNumber,
      "photo": this.photo,
    };
  }

  Map toCleanedJson() {
    if (phoneNumber.isNotEmpty)
      return {
        "name": this.name,
        "phoneNumber": this
            .phoneNumber
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll('-', '')
            .replaceAll(' ', '')
            .trim()
      };
    else if (emailAddress.isNotEmpty)
      return {"name": this.name, "emailaddress": this.emailAddress};
    else
      return {};
  }

  factory PluhgContact.fromJson(Map json) => PluhgContact(
    id: '',
    photo: null,
    name: json['name'],
    isPlughedUser: json['isPlughedUser'] ?? false,
    phoneNumber: json['phoneNumber'] ?? '',
    emailAddress: json['emailaddress'] ?? '',
  );

  factory PluhgContact.fromContact(Contact contact) {
    return PluhgContact(
      id: contact.id,
      name: contact.displayName,
      isPlughedUser: false,
      // photo: '',//contact.photo,
      phoneNumber: contact.phones.isNotEmpty ? contact.phones.first.number : '',
      emailAddress:
      contact.emails.isNotEmpty ? contact.emails.first.address : '',
    );
  }
}
