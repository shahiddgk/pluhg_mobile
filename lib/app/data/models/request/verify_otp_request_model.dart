class VerifyOtpRequestModel {
  String? emailAddress;
  String? phoneNumber;
  String? code;
  String? type;
  String? deviceToken;

  VerifyOtpRequestModel(
      {this.emailAddress,
      this.phoneNumber,
      this.code,
      this.type,
      this.deviceToken});

  VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    code = json['code'];
    type = json['type'];
    deviceToken = json['deviceToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailAddress'] = this.emailAddress?.toLowerCase();
    data['phoneNumber'] = this.phoneNumber;
    data['code'] = this.code;
    data['type'] = this.type;
    data['deviceToken'] = this.deviceToken;
    return data;
  }
}
