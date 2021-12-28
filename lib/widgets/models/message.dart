class Message {
  String? id;
  String type;
  String message;
  String time;
  String image;
  bool isRead;
  bool isDeleted;
  String messageType;
  String date;
  Message({
    this.id,
    required this.message,
    required this.type,
    required this.time,
    required this.image,
    required this.isDeleted,
    required this.isRead,
    required this.date,
    required this.messageType,
  });
}
