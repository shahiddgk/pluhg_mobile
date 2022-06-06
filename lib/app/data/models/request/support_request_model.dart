class SupportRequestModel {
  String? emailAddress;
  String? subject;
  String? emailContent;

  SupportRequestModel({this.emailAddress, this.subject, this.emailContent});

  SupportRequestModel.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    subject = json['subject'];
    emailContent = json['emailContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailAddress'] = this.emailAddress;
    data['subject'] = this.subject;
    data['emailContent'] = this.emailContent;
    return data;
  }
}
