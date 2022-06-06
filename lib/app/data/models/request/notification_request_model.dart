class NotificationRequestModel {
  List<String> notificationId=[];

  NotificationRequestModel({required this.notificationId});

  NotificationRequestModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationId'] = this.notificationId;
    return data;
  }
}
