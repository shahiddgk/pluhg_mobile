import 'package:plug/app/modules/contact/model/pluhg_contact.dart';

class CheckContactRequestModel {
  List<PluhgContact>? pluhgContacts;

  CheckContactRequestModel({this.pluhgContacts});

  // CheckContactRequestModel.fromJson(Map<String, dynamic> json) {
  //   pluhgContacts = PluhgContact.fromJson(json);
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contacts'] =
        this.pluhgContacts?.map((item) => item.toJson()).toList();
    return data;
  }
}
