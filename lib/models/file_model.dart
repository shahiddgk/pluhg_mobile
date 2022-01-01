class FileModel {
  late String fileName;
  late String url;

  FileModel({required this.url, required this.fileName});

  FileModel.fromJson(Map<String, dynamic> json) {
    fileName = json['resource'];
    url = json['url'];
  }
}
