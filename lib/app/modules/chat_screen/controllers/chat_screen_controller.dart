import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/widgets/models/user_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {
  //TODO: Implement ChatScreenController
  late IO.Socket socket;
  List<UserChat> users = [];
  final size = Get.size;
  String? userID;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    connect();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString(prefuserid).toString();
    socket = IO.io("ws://3.18.123.250", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) {
      print('Connected.');
      print(userID.toString());

      getMessages(userID.toString());
    });
  }

  void getMessages(String userId) {
    print(userId);
    socket.emit('getMessages', {'userId': userId});
    socket.on('getMessagesResponse', (data) {
      var chatsArr = data['data'];
      users = List<UserChat>.from(chatsArr
          .map((dynamic message) => UserChat.fromJson(message))
          .toList());
      /*for (int i = 0; i < chatsArr.length; i++) {
        setMessageResponse(chatsArr[i]);
      }*/
    });
  }

  void setMessageResponse(dynamic message) {
    print("--------------------");
    print(message['createdAt'].toString());

    /*users.add(
      UserChat(
        name: message['receiverDetails']['name'],
        profileImage: message['receiverDetails']['profileImage'],
        senderId: message['senderDetails']['_id'],
        recevierId: message['receiverDetails']['_id'],
        id: ""/*message['_id']*/,
        messageType: "",
        message: message['message'],
        // time: message['createdAt'].toString(),
        // date: message['createdAt'].toString(),

        time: "",//DateFormat('hh:mm a').format(DateTime.parse(message['createdAt'])).toString(),
        // date:
        //     DateFormat('dd MMMM, yyyy').format(message['createdAt']).toString(),
        // type: message['senderId'] == userID ? 'source' : 'destination',
        isRead: message['isRead'],
        isDeleted: false/*message['isDeleted']*/,
      ),
    );*/
  }
}
