class UpdateProfileRequestModel {
  String? address;
  String? emailAddress;
  String? phoneNumber;
  String? userName;
  String? name;

  UpdateProfileRequestModel(
      {this.address,
      this.emailAddress,
      this.phoneNumber,
      this.userName,
      this.name});

  UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    userName = json['userName'];
    name = json['name'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    if ((this.address ?? "").isNotEmpty) data['address'] = this.address!;
    if ((this.emailAddress ?? "").isNotEmpty)
      data['emailAddress'] = this.emailAddress!.toLowerCase();
    if ((this.phoneNumber ?? "").isNotEmpty)
      data['phoneNumber'] = this.phoneNumber!;
    if ((this.userName ?? "").isNotEmpty) data['userName'] = this.userName!;
    if ((this.name ?? "").isNotEmpty) data['name'] = this.name!;
    return data;
  }
}
