import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
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
    userID = prefs.getString("userID");
    socket = IO.io("ws://3.18.123.250", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) {
      print('Connected.');
      getMessages(userID!);
    });
  }

  void getMessages(String userId) {
    socket.emit('getMessages', {'userId': userId});
    print('getting chats');
    socket.on('getMessagesResponse', (data) {
      print(data);

// get the list of messages
      var chatsArr = data['data'];
      // messages = [];
      for (int i = 0; i < chatsArr.length; i++) {
        setMessageResponse(chatsArr[i]);
      }
    });
  }

  void setMessageResponse(dynamic message) {
    users.add(
      UserChat(
        name: message['recevierId']['name'],
        profileImage: message['recevierId']['profileImage'],
        senderId: message['senderId']['_id'],
        recevierId: message['recevierId']['_id'],
        id: message['_id'],
        messageType: message['messageType'],
        message: message['message'],
        // time: message['createdAt'].toString(),
        // date: message['createdAt'].toString(),

        time: DateFormat('hh:mm a').format(DateTime.parse(message['createdAt'])).toString(),
        // date:
        //     DateFormat('dd MMMM, yyyy').format(message['createdAt']).toString(),
        // type: message['senderId'] == userID ? 'source' : 'destination',
        isRead: message['isRead'],
        isDeleted: message['isDeleted'],
      ),
    );
  }
}
