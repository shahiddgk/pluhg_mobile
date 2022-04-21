import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';

class PluhgContact {
  bool isPlughedUser = false;
  String? id;
  Uint8List? photo;
  String name, phoneNumber, emailAddress;
  List<String> phoneNumbers;
  List<String> emailAddresses;
  String? selectedContact;

  PluhgContact({
    required this.id,
    required this.name,
    required this.phoneNumbers,
    required this.phoneNumber,
    this.photo,
    required this.emailAddress,
    required this.isPlughedUser,
    required this.emailAddresses,
    this.selectedContact,
  });

  PluhgContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    List<String>? phoneNumbers,
    Uint8List? photo,
    String? emailAddress,
    bool? isPlughedUser,
    List<String>? emailAddresses,
    String? selectedContact,
  }) {
    return PluhgContact(
      phoneNumbers: phoneNumbers!,
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      emailAddress: emailAddress ?? this.emailAddress,
      isPlughedUser: isPlughedUser ?? this.isPlughedUser,
       emailAddresses:  emailAddresses ?? this.emailAddresses,
      selectedContact:  selectedContact ?? this.selectedContact,
    );
  }

  @override
  String toString() {
    return ""
        "{id: ${this.id}, name: ${this.name}, emailAddress: ${this.emailAddress}, isPlughedUser: ${this.isPlughedUser}, "
        "phoneNumber: ${this.phoneNumber}, photo: ${this.photo}, emailAddresses : ${this.emailAddresses}}";
  }

  Map toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "emailAddress": this.emailAddress,
      "isPlughedUser": this.isPlughedUser,
      "phoneNumber": this.phoneNumber,
      "photo": this.photo,
      "emailAddresses" : this.emailAddresses,
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
        phoneNumbers: [],
        id: '',
        photo: null,
        name: json['name'],
        isPlughedUser: json['isPlughedUser'] ?? false,
        phoneNumber: json['phoneNumber'] ?? '',
        emailAddress: json['emailaddress'] ?? '',
       emailAddresses: json['emailAddresses'] ?? '',
      );

  factory PluhgContact.fromContact(Contact contact) {
    return PluhgContact(
      phoneNumbers: contact.phones.map((e) => e.number).toList(),
      id: contact.id,
      name: contact.displayName,
      isPlughedUser: false,
      // photo: '',//contact.photo,
      phoneNumber: contact.phones.isNotEmpty ? contact.phones.first.number : '',
      emailAddress: contact.emails.isNotEmpty ? contact.emails.first.address : '',
      emailAddresses: contact.emails.isNotEmpty ? contact.emails.map((e) => e.address).toList() : [],
    );
  }
}
