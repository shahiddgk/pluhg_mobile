import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/utils/validation_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactController extends GetxController with ValidationMixin{
  //TODO: Implement ContactController

  final count = 0.obs;
  List<PluhgContact> _allContacts = [];
  Completer<List<PluhgContact>> contactsFuture = Completer();

  // List<PluhgContact> contacts_ = [];
  RxBool permissionDenied = false.obs;
  RxBool isContactPluhg = false.obs;
  RxBool isRequesterPluhg = false.obs;

  Uint8List? contactImage;
  Uint8List? requesterImage;
  RxString contactName = "".obs;
  RxString requesterName = "".obs;
  RxString requesterId = "".obs;
  RxString search = "".obs;
  RxString contactContact = "".obs;
  RxString contactId = "".obs;

  RxString requesterContact = "".obs;

  RxString title = "Select Requester".obs;
  RxString status = "".obs;
  SharedPreferences? prefs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    getContactList();
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

  void getContactList() async {
    if (contactsFuture.isCompleted) {
      return;
    }

    //Request access contact permission
    final perm = await Permission.contacts.request();

    print(perm.isDenied);
    if (perm.isDenied) {
      permissionDenied.value = true;
      return;
    } else {

      //get list contact from phone
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true, withThumbnail: true,withAccounts: true);

      // check for registered users
      List<PluhgContact> pluhgContacts = [];
      try {

        pluhgContacts = contacts
            .map<PluhgContact>((contact) => PluhgContact.fromContact(contact))
            .toList();
      } catch (ex) {
        print(ex);
      }

      _allContacts = await APICALLS().checkPluhgUsers(contacts: pluhgContacts);
      //remove users phone number
      String userPhoneNumber = prefs!.getString(prefuserphone) ?? "";
      String userEmail = prefs!.getString(prefuseremail) ?? "";
      PluhgContact? contactToRemove;
      _allContacts.forEach((element) {
        if (comparePhoneNumber(element.phoneNumber,(userPhoneNumber)) ||
            comparePhoneNumber(element.emailAddress,userEmail)) {
          contactToRemove = element;
        }
        ;
      });
      if (contactToRemove != null) {
        _allContacts.remove(contactToRemove);
      }
      contactsFuture.complete(_allContacts);
    }
  }

  //Get Pluhg Contacts
  List<PluhgContact> get contacts_ => _allContacts.where((contact) {
        final regexp = RegExp(search.value, caseSensitive: false);
        return regexp.hasMatch(contact.name);
      }).toList();
}
