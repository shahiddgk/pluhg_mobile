class NotificationSettingsRequestModel {
  bool? textNotification;
  bool? emailNotification;
  bool? pushNotification;

  NotificationSettingsRequestModel(
      {this.textNotification, this.emailNotification, this.pushNotification});

  NotificationSettingsRequestModel.fromJson(Map<String, dynamic> json) {
    textNotification = json['textNotification'];
    emailNotification = json['emailNotification'];
    pushNotification = json['pushNotification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textNotification'] = this.textNotification;
    data['emailNotification'] = this.emailNotification;
    data['pushNotification'] = this.pushNotification;
    return data;
  }
}
