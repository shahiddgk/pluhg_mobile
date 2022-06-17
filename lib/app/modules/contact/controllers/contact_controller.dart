import 'dart:async';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_number/phone_number.dart';
import 'package:plug/app/modules/contact/model/pluhg_contact.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/utils/validation_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/snack_bar.dart';

class ContactController extends GetxController with ValidationMixin {
  //TODO: Implement ContactController

  final count = 0.obs;
  List<PluhgContact> _allContacts = [];
  Completer<List<PluhgContact>> contactsFuture = Completer();

  RxBool permissionDenied = false.obs;
  Rx<PluhgContact> requesterGroup = PluhgContact.empty().obs;
  Rx<PluhgContact> contactGroup = PluhgContact.empty().obs;

  Rx<ContactData> requesterContact = ContactData.empty().obs;
  Rx<ContactData> contactContact = ContactData.empty().obs;
  RxString search = "".obs;

  // RxBool isContactPluhg = false.obs;
  // RxBool isRequesterPluhg = false.obs;

  // Uint8List? contactImage;
  // Uint8List? requesterImage;
  // RxString contactName = "".obs;
  // RxString requesterName = "".obs;
  // RxString requesterId = "".obs;
  // RxString search = "".obs;
  // RxString contactContact = "".obs;
  // RxString contactId = "".obs;
  //
  // RxString requesterContact = "".obs;

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
    if (contact.emails.isNotEmpty && contact.emails.first.address.isNotEmpty) {
      return contact.emails.first.address;
    } else {
      return contact.phones.first.normalizedNumber;
    }
  }

  Future<bool> checkPermissions() async {
    ///Request access contact permission
    final perm = await Permission.contacts.request();
    if (perm.isDenied) {
      permissionDenied.value = true;
      pluhgSnackBar("So sorry", "Permission denied");
    }
    return perm.isGranted;
  }

  Future<List<Contact>> readContacts() async {
    //get list contact from phone
    var contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
      withThumbnail: true,
      withAccounts: true,
    );
    return contacts;
  }

  Future<List<Contact>> removeInvalidContacts(
      User user, List<Contact> contacts) async {
    //final inValidCharacters = RegExp(r'^[\=,\.\*;]+$');
    final inValidCharacters = RegExp(r'^[\=,\.\*#;]+$');
    contacts.removeWhere((element) {
      bool remove = false;
      element.phones.forEach((element) {
        if (element.number.length < 7 ||
            inValidCharacters.hasMatch(element.number) || element.number.contains("*") || element.number.contains("#")) {
          remove = true;
          return;
        }
      });
      return remove;
    });

    return contacts;
  }

  Future<List<Contact>> validateAndFormatContacts(
      User user, List<Contact> contacts) async {
    PhoneNumberUtil plugin = PhoneNumberUtil();
    List<RegionInfo> regions = await plugin.allSupportedRegions();
    for (int i = 0; i < contacts.length; i++) {
      Contact element = contacts[i];
      List<Address> addresses = element.addresses;
      for (int j = 0; j < element.phones.length; j++) {
        Phone element2 = element.phones[j];
        final contactPhoneNumber = formatPhoneNumber(element2.number);
        final newPhoneNumber;
        RegionInfo region;
        if (addresses.length > 0) {
          String iso = addresses[0].isoCountry.isNotEmpty
              ? addresses[0].isoCountry.toLowerCase()
              : user.regionCode.toLowerCase();
          region = regions
              .firstWhere((element) => element.code.toLowerCase() == iso);
        } else {
          region = RegionInfo(
              name: user.regionCode,
              code: user.regionCode,
              prefix: int.parse(user.countryCode));
        }
        //try {
        bool isValid = await plugin.validate(contactPhoneNumber, region.code);
        if (isValid) {
          PhoneNumber phoneNumber =
              await plugin.parse(contactPhoneNumber, regionCode: region.code);
          newPhoneNumber = phoneNumber.e164;
        } else {
          newPhoneNumber =
              contactPhoneNumber.replaceAll(new RegExp(r'^00+(?=.)'), '+');
        }
        element2.number = newPhoneNumber;
        // } catch (e) {
        //   element2.number = "";
        // }
      }
    }
    return contacts;
  }

  Future<List<PluhgContact>> checkPluhgContacts(
      User user, List<Contact> contacts) async {
    List<PluhgContact> _allContacts = [];

    List<PluhgContact> pluhgContacts = [];
    try {
      pluhgContacts = contacts
          .map<PluhgContact>((contact) => PluhgContact.fromContact(contact))
          .toList();
    } catch (ex) {
      print(ex);
    }
    // HTTPManager()
    //     .checkIfPluhgUsers(
    //         CheckContactRequestModel(pluhgContacts: pluhgContacts))
    //     .then((value) => {})
    //     .catchError((onError) {});

    // _allContacts = await APICALLS().checkPluhgUsers(contacts: pluhgContacts);
    //
    //  _allContacts.removeWhere((element) =>
    //      comparePhoneNumber(element.phoneNumber, user.phone) ||
    //      comparePhoneNumber(element.emailAddress, user.email));

    pluhgContacts.removeWhere((element) {
      bool contactExists = false;
      element.contacts.forEach((element) {
        if (comparePhoneNumber(element.value, user.phone) ||
            comparePhoneNumber(element.value, user.email)) {
          contactExists = true;
          return;
        }
      });
      return contactExists;
    });

    _allContacts.clear();
    _allContacts.addAll(pluhgContacts);
    return _allContacts;
  }

  void getContactList() async {
    User user = await UserState.get();
    checkPermissions().then((value) {
      // if (value) {
      readContacts().then((contacts) {
        removeInvalidContacts(user, contacts).then((validContacts) {
          validateAndFormatContacts(user, validContacts)
              .then((validatedContacts) {
            checkPluhgContacts(user, validatedContacts).then((allContacts) {
              _allContacts.clear();
              _allContacts.addAll(allContacts);
              contactsFuture.complete(_allContacts);
            });
          });
        });
      });
      // }else{
      //   contactsFuture.complete(_allContacts);
      // }
    });
  }

  void selectRequester(PluhgContact pluhgContact, ContactData contactData) {
    requesterGroup.value.isSelected = false;
    requesterContact.value.isSelected = false;

    pluhgContact.isSelected = true;
    contactData.isSelected = true;
    requesterGroup.value = pluhgContact;
    requesterContact.value = contactData;
  }

  void unSelectRequester(PluhgContact pluhgContact, ContactData contactData) {
    pluhgContact.isSelected = false;
    contactData.isSelected = false;
    requesterContact.value = ContactData.empty();
  }

  void selectContact(PluhgContact pluhgContact, ContactData contactData) {
    contactGroup.value.isSelected = false;
    contactContact.value.isSelected = false;

    pluhgContact.isSelected = true;
    contactData.isSelected = true;
    contactGroup.value = pluhgContact;
    contactContact.value = contactData;
  }

  void unSelectContact(PluhgContact pluhgContact, ContactData contactData) {
    pluhgContact.isSelected = false;
    contactData.isSelected = false;
    contactContact.value = ContactData.empty();
  }

  //Get Pluhg Contacts
  List<PluhgContact> get contacts_ => _allContacts.where((contact) {
        final regexp = RegExp(search.value, caseSensitive: false);
        return regexp.hasMatch(contact.name);
      }).toList();

  List<PluhgContact> get fetchAllContacts => _allContacts;
}
