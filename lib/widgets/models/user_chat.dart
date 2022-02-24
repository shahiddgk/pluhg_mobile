import 'package:intl/intl.dart';

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
  int unReadCount;
  String userName;

  UserChat({
    this.id,
    required this.message,
    required this.isRead,
    required this.isDeleted,
    required this.userName,
    required this.unReadCount,
    required this.messageType,
    required this.senderId,
    required this.recevierId,
    required this.profileImage,
    required this.name,
    required this.time,
  });

  factory UserChat.fromJson(Map message) {
    var chatMaster = message["chatMaster"];
    return UserChat(
      userName: chatMaster['receiverDetails']['userName'].toString(),
      unReadCount: chatMaster["unReadCount"],
      name: chatMaster['receiverDetails']['name'].toString(),
      profileImage: chatMaster['receiverDetails']['profileImage'],
      senderId: chatMaster['senderDetails']['_id'],
      recevierId: chatMaster['receiverDetails']['_id'],
      id: message['_id'],
      messageType: "",
      message: message['message'],
      time: DateFormat('hh:mm a').format(DateTime.parse(message['createdAt'])).toString(),
      isRead: message['isRead'] == null ? false : message['isRead'],
      isDeleted: false /*message['isDeleted']*/,
    );
  }
}
