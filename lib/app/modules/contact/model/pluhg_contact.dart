import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';

class PluhgContact {
  String? id;
  Uint8List? photo;
  String name;

  // String phoneNumber, emailAddress;
  List<ContactData> contacts;

  // List<ContactData> emailAddresses;
  bool isSelected = false;

  PluhgContact({
    required this.id,
    required this.name,
    required this.contacts,
    //required this.phoneNumber,
    this.photo,
    //required this.emailAddress,
    //required this.isPlughedUser,
    //required this.emailAddresses,
    this.isSelected = false,
  });

  factory PluhgContact.empty() {
    return PluhgContact(
        id: "",
        name: "",
        // phoneNumber: "",
        contacts: [],
        //emailAddress: "",
        //isPlughedUser: false,
        // emailAddresses: [],
        isSelected: false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contacts'] = this.contacts?.map((item) => item.toJson()).toList();
    return data;
  }

  // PluhgContact copyWith({
  //   String? id,
  //   String? name,
  //   String? phoneNumber,
  //   List<ContactData>? phoneNumbers,
  //   Uint8List? photo,
  //   String? emailAddress,
  //   bool? isPlughedUser,
  //   List<ContactData>? emailAddresses,
  //   bool selectedContact = false,
  // }) {
  //   return PluhgContact(
  //     contacts: phoneNumbers!,
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     //phoneNumber: phoneNumber ?? this.phoneNumber,
  //     photo: photo ?? this.photo,
  //     //emailAddress: emailAddress ?? this.emailAddress,
  //     isPlughedUser: isPlughedUser ?? this.isPlughedUser,
  //    // emailAddresses: emailAddresses ?? this.emailAddresses,
  //     isSelected: selectedContact,
  //   );
  // }

  // @override
  // String toString() {
  //   return ""
  //       "{id: ${this.id}, name: ${this.name}, "
  //       "photo: ${this.photo}, contacts : ${this.contacts}}";
  //   // return ""
  //   //     "{id: ${this.id}, name: ${this.name}, emailAddress: ${this.emailAddress}, isPlughedUser: ${this.isPlughedUser}, "
  //   //     "phoneNumber: ${this.phoneNumber}, photo: ${this.photo}, emailAddresses : ${this.emailAddresses}}";
  // }

  // Map toJson() {
  //   return {
  //     "id": this.id,
  //     "name": this.name,
  //     //  "emailAddress": this.emailAddress,
  //     //"isPlughedUser": this.isPlughedUser,
  //     //  "phoneNumber": this.phoneNumber,
  //     "photo": this.photo,
  //     //  "emailAddresses": this.emailAddresses,
  //   };
  // }

  // Map toCleanedJson() {
  //   if (phoneNumber.isNotEmpty)
  //     return {
  //       "name": this.name,
  //       "phoneNumber": this
  //           .phoneNumber
  //           .replaceAll('(', '')
  //           .replaceAll(')', '')
  //           .replaceAll('-', '')
  //           .replaceAll(' ', '')
  //           .trim()
  //     };
  //   else if (emailAddress.isNotEmpty)
  //     return {"name": this.name, "emailaddress": this.emailAddress};
  //   else
  //     return {};
  // }

  // factory PluhgContact.fromJson(Map json) => PluhgContact(
  //       contacts: [],
  //       id: '',
  //       photo: null,
  //       name: json['name'],
  //       //isPlughedUser: json['isPlughedUser'] ?? false,
  //       // phoneNumber: json['phoneNumber'] ?? '',
  //       // emailAddress: json['emailaddress'] ?? '',
  //       // emailAddresses: json['emailAddresses'] ?? '',
  //     );

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
      //isPlughedUser: false,
      // photo: '',//contact.photo,
      // phoneNumber: contact.phones.isNotEmpty ? contact.phones.first.number : '',
      //  emailAddress:
      //     contact.emails.isNotEmpty ? contact.emails.first.address : '',
      // emailAddresses: contact.emails.isNotEmpty
      //     ? contact.emails
      //         .map(
      //             (e) => ContactData(value: e.address, type: ContactType.email))
      //         .toList()
      //     : [],
    );
  }
}

enum ContactType {
  email,
  phone,
}

class ContactData {
  final String name;
  final Uint8List? image;
  final String value;
  final ContactType type;
  bool isSelected;
  bool isPlughedUser = false;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact'] = this.value;
    data['isPlughedUser'] = this.isPlughedUser;
    data['type'] = this.type.name;
    return data;
  }
}
