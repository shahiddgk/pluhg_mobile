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

  UserChat({
    this.id,
    required this.message,
    required this.isRead,
    required this.isDeleted,
    required this.unReadCount,
    required this.messageType,
    required this.senderId,
    required this.recevierId,
    required this.profileImage,
    required this.name,
    required this.time,
  });

  factory UserChat.fromJson(Map message) => UserChat(
    unReadCount: message["chatMaster"]["unReadCount"],
    name: message["chatMaster"]['receiverDetails']['name'],
    profileImage: message["chatMaster"]['receiverDetails']['profileImage'],
    senderId: message["chatMaster"]['senderDetails']['_id'],
    recevierId: message["chatMaster"]['receiverDetails']['_id'],
    id: "" /*message['_id']*/,
    messageType: "",
    message: message['message'],
    time: DateFormat('hh:mm a')
        .format(DateTime.parse(message['timeStamp']))
        .toString(),
    isRead: message['isRead'] == null ? false : message['isRead'],
    isDeleted: false /*message['isDeleted']*/,
  );
}
