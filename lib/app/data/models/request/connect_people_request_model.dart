class ConnectPeopleRequestModel {
  Requester? requester;
  Requester? contact;
  String? both;
  String? requesterMessage;
  String? contactMessage;

  ConnectPeopleRequestModel(
      {this.requester,
        this.contact,
        this.both,
        this.requesterMessage,
        this.contactMessage});

  ConnectPeopleRequestModel.fromJson(Map<String, dynamic> json) {
    requester = json['requester'] != null
        ? new Requester.fromJson(json['requester'])
        : null;
    contact = json['contact'] != null
        ? new Requester.fromJson(json['contact'])
        : null;
    both = json['both'];
    requesterMessage = json['requesterMessage'];
    contactMessage = json['contactMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requester != null) {
      data['requester'] = this.requester!.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
    }
    data['both'] = this.both;
    data['requesterMessage'] = this.requesterMessage;
    data['contactMessage'] = this.contactMessage;
    return data;
  }
}

class Requester {
  String? contact;
  String? name;
  String? contactType;
  String? message;

  Requester({this.contact, this.name, this.contactType, this.message});

  Requester.fromJson(Map<String, dynamic> json) {
    contact = json['contact'];
    name = json['name'];
    contactType = json['contactType'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    data['name'] = this.name;
    data['contactType'] = this.contactType;
    data['message'] = this.message;
    return data;
  }
}