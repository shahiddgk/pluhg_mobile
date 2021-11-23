class UserChat {
  String? id;
  String message;
  bool isRead;
  bool isDeleted;
  String messageType;
  String senderId;
  String recevierId;
  String? profileImage;
  String name;
  String time;

  UserChat({
    this.id,
    required this.message,
    required this.isRead,
    required this.isDeleted,
    required this.messageType,
    required this.senderId,
    required this.recevierId,
    required this.profileImage,
    required this.name,
    required this.time,
  });
}