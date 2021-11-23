import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plug/app/widgets/snack_bar.dart';
import 'package:plug/widgets/dialog_box.dart';

class ContactController extends GetxController {
  //TODO: Implement ContactController

  final count = 0.obs;
  List<Contact> contacts_ = [];
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
  List<Contact> contactsSelected = [];

  RxString person = "Select Requester".obs;
  RxString status = "".obs;
  @override
  void onInit() {
    super.onInit();
    // pluhgSnackBar('Loading', 'Please wait, loading contacts takes few minutes');
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

  Future getContactList() async {
    final perm = await Permission.contacts.request();

    print(perm.isDenied);
    if (perm.isDenied) {
      permissionDenied.value = true;
      return null;
    } else {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true, withThumbnail: true);
      //to check for a pluhg user
      // for (var i in contacts) {
      //   if (i.phones.isNotEmpty) {
      //     var value = await checkPluhgUsers(
      //         contact: i.phones.first.normalizedNumber, name: i.displayName);
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
      contacts_ = contacts;
      return contacts;
    }
  }
}
