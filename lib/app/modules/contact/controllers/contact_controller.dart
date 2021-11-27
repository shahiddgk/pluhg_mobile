import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactController extends GetxController {
  //TODO: Implement ContactController

  final count = 0.obs;
  List<PluhgContact> contacts_ = [];
  RxBool permissionDenied = false.obs;

  Uint8List? contactImage;
  Uint8List? requesterImage;
  RxString contactName = "".obs;
  RxString requesterName = "".obs;
  RxString requesterId = "".obs;
  RxString search = "".obs;
  RxString contactContact = "".obs;
  RxString contactId = "".obs;

  RxString requesterContact = "".obs;

  RxString person = "Select Requester".obs;
  RxString status = "".obs;
  SharedPreferences? prefs;
  @override
  void onInit() {
    super.onInit();
    init();
    // pluhgSnackBar('Loading', 'Please wait, loading contacts takes few minutes');
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  String getContact({required Contact contact}) {
    if (contact.emails.isNotEmpty && contact.emails.first.address != null) {
      return contact.emails.first.address;
    } else {
      return contact.phones.first.normalizedNumber;
    }
  }

  Future<List<PluhgContact>> getContactList() async {
    final perm = await Permission.contacts.request();

    print(perm.isDenied);
    if (perm.isDenied) {
      permissionDenied.value = true;
      return [];
    } else {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true, withThumbnail: true);
      //to check for a pluhg user
      // for (var i in contacts) {
      //   if (i.phones.isNotEmpty) {
      // var value = await checkPluhgUsers(
      //     contact: i.phones.first.normalizedNumber, name: i.displayName);
      //     if (value == "true") {
      //       _statusSelected.add("Pluhg user");
      //     } else {
      //       _statusSelected.add("not a Pluhg user");
      //     }
      //     print(value);
      //     setState(() {});
      //   }
      //   if (i.emails.isNotEmpty) {
      //     var value = await checkPluhgUsers(
      //         contact: i.emails.first.address, name: i.displayName);
      //     if (value == "true") {
      //       _statusSelected.add("Pluhg user");
      //     } else {
      //       _statusSelected.add("not a Pluhg user");
      //     }
      //     print(value);
      //     setState(() {});
      //   }
      // }

      // check for registered users
      List<PluhgContact> pluhgContacts = [];
      try {
        pluhgContacts = contacts
            .map<PluhgContact>((contact) => PluhgContact.fromContact(contact))
            .toList();
      } catch (ex) {
        print('xxxsxsss');
        print(ex);
      }

      contacts_= await APICALLS().checkPluhgUsers(contacts: pluhgContacts);
      return contacts_;
    }
  }
}
