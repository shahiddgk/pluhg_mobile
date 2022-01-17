import 'package:intl/intl.dart';

class Message {
  String? id;
  String type;
  dynamic message;
  String time;
  bool isRead;
  bool isDeleted;
  String messageType;
  String date;
  String senderId;

  Message({
    this.id,
    required this.message,
    required this.type,
    required this.time,
    required this.isDeleted,
    required this.isRead,
    required this.senderId,
    required this.date,
    required this.messageType,
  });

  factory Message.fromJson2(Map message, myid, senderId) {
    print("------");
    print(message);

    return Message(
      id: message['_id'].toString(),
      senderId: senderId,
      messageType:
          message['messageType'] == null ? "text" : message['messageType'],
      message: message['messageType'] == null ? "" : message['message'],
      time: message['createdAt'] == null
          ? ""
          : DateFormat('hh:mm a')
              .format(DateTime.parse(message['createdAt']))
              .toString(),
      date: DateFormat('dd MMMM, yyyy').format(DateTime.now()).toString(),
      type: senderId == myid ? 'source' : 'destination',
      isRead: /*message['senderId'] == myid ? true :*/ message['isRead'],
      isDeleted: message['isDeleted'],
    );
  }

  factory Message.fromJson(Map message, myid) {
    return Message(
      id: message['_id'].toString(),
      senderId: message["chatId"]["senderId"]['_id'],
      messageType:
          message['messageType'] == null ? "text" : message['messageType'],
      message: message['messageType'] == null ? "" : message['message'],
      time: message['createdAt'] == null
          ? ""
          : DateFormat('hh:mm a')
              .format(DateTime.parse(message['createdAt']))
              .toString(),
      date: DateFormat('dd MMMM, yyyy')
          .format(DateTime.parse(message['createdAt']))
          .toString(),
      type: message["chatId"]["senderId"]['_id'] == myid
          ? 'source'
          : 'destination',
      isRead: message['receiverId'] == myid ? true : message['isRead'],
      isDeleted: message['isDeleted'],
    );
  }
}
