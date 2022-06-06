class LoginRequestModel {
  String? emailAddress;
  String? phoneNumber;
  String? type;

  LoginRequestModel({this.emailAddress, this.phoneNumber, this.type});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailAddress'] = this.emailAddress;
    data['phoneNumber'] = this.phoneNumber;
    data['type'] = this.type;
    return data;
  }
}