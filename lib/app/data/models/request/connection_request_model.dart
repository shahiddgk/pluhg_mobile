class ConnectionRequestModel {
  String? connectionId;
  String? reason;
  String? feedbackRating;

  ConnectionRequestModel({this.connectionId,this.reason, this.feedbackRating});

  ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    connectionId = json['connectionId'];
    reason = json['reason'];
    feedbackRating = json['feedbackRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connectionId'] = this.connectionId;
    data['reason'] = this.reason;
    data['feedbackRating'] = this.feedbackRating;
    return data;
  }
}
