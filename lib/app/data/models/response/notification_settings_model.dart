class NotificationSettingsModel {
  String? sId;
  String? userId;
  bool? pushNotification;
  bool? emailNotification;
  bool? textNotification;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotificationSettingsModel(
      {this.sId,
        this.userId,
        this.pushNotification,
        this.emailNotification,
        this.textNotification,
        this.createdAt,
        this.updatedAt,
        this.iV});

  NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    pushNotification = json['pushNotification'];
    emailNotification = json['emailNotification'];
    textNotification = json['textNotification'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['pushNotification'] = this.pushNotification;
    data['emailNotification'] = this.emailNotification;
    data['textNotification'] = this.textNotification;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}