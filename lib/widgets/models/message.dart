import 'package:intl/intl.dart';

const MESSAGE_TYPE_SOURCE = 'source';
const MESSAGE_TYPE_DESTINATION = 'destination';

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
    print("[Message:fromJson2] create ${message.toString()}");
    return Message(
      id: message['_id'].toString(),
      senderId: senderId,
      messageType: message['messageType'] == null ? "text" : message['messageType'],
      message: message['message'] == null ? "" : message['message'],
      time: message['createdAt'] == null
          ? ""
          : DateFormat('hh:mm a').format(DateTime.parse(message['createdAt'])).toString(),
      date: DateFormat('dd MMMM, yyyy').format(DateTime.now()).toString(),
      type: senderId == myid ? MESSAGE_TYPE_SOURCE : MESSAGE_TYPE_DESTINATION,
      isRead: message['isRead'],
      isDeleted: false /*message['isDeleted']*/,
    );
  }

  factory Message.fromJson(Map message, myid) {
    print("[Message:fromJson] create ${message.toString()}");
    var chatMaster = message["chatId"];
    return Message(
      id: message['_id'].toString(),
      senderId: chatMaster["senderId"]['_id'],
      messageType: message['messageType'] == null ? "text" : message['messageType'],
      message: message['message'] == null ? "" : message['message'],
      time: message['createdAt'] == null
          ? ""
          : DateFormat('hh:mm a').format(DateTime.parse(message['createdAt'])).toString(),
      date: DateFormat('dd MMMM, yyyy').format(DateTime.parse(message['createdAt'])).toString(),
      type: message['creatorId'] == myid ? MESSAGE_TYPE_SOURCE : MESSAGE_TYPE_DESTINATION,
      isRead: chatMaster['recevierId']['_id'] == myid ? true : message['isRead'],
      isDeleted: message['isDeleted'],
    );
  }

  bool isMine() {
    return isSource();
  }

  bool isSource() {
    return this.type == MESSAGE_TYPE_SOURCE;
  }

  bool isDestination() {
    return this.type == MESSAGE_TYPE_SOURCE;
  }
}
