class CreateProfileRequestModel {
  String? phoneNumber;
  String? emailAddress;
  String? userName;
  String? deviceToken;

  CreateProfileRequestModel(
      {this.userName, this.phoneNumber, this.emailAddress, this.deviceToken});

  CreateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    // if (contactType == User.PHONE_CONTACT_TYPE) {
    //   phoneNumber = json['phoneNumber'];
    // } else {
    //   phoneNumber = json['emailAddress'];
    // }
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    emailAddress = json['emailAddress'];
    deviceToken = json['deviceToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //if (contactType == User.PHONE_CONTACT_TYPE) {
    data['phoneNumber'] = this.phoneNumber;
    // } else {
    data['emailAddress'] = this.emailAddress?.toLowerCase();
    //  }
    data['userName'] = this.userName;
    data['deviceToken'] = this.deviceToken;
    return data;
  }
}
