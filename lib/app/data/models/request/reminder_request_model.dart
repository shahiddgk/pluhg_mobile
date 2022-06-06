class ReminderRequestModel {
  String? connectionId;
  String? message;
  String? party;

  ReminderRequestModel({this.connectionId, this.message, this.party});

  ReminderRequestModel.fromJson(Map<String, dynamic> json) {
    connectionId = json['connectionId'];
    message = json['message'];
    party = json['party'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connectionId'] = this.connectionId;
    data['message'] = this.message;
    data['party'] = this.party;
    return data;
  }
}