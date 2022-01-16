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

  factory Message.fromJson(Map message, myid) {
    /* if (message['senderId'] == null)
      return Message(
          date: '',
          type: '',
          time: '',
          messageType: '',
          message: '',
          isRead: false,
          isDeleted: false,
          senderId: '');
    else {*/
    /*String senderId = message['senderId'].runtimeType.toString() == "String"
          ? message['senderId']
          : message['senderId']["_id"].toString();*/

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
