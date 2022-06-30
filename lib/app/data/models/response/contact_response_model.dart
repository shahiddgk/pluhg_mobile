import 'package:plug/app/modules/contact/model/pluhg_contact.dart';

class ContactResponseModel {
  List<PluhgContact> values = [];

  ContactResponseModel() {
    values = [];
  }

  ContactResponseModel.fromJson(var jsonObject) {
    if (jsonObject != null) {
      for (var area in jsonObject) {
        PluhgContact model = PluhgContact.fromJson(area);
        this.values.add(model);
      }
    }
  }
}
