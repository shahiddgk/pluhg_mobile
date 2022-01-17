import 'dart:async';

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



  RxList users = [].obs;
  List<UserChat> usersTemp = [];




  final size = Get.size;
  String? userID;
  final count = 0.obs;
  int total_unread_messages = 0;
  RxString search = "".obs;


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
    socket = IO.io(APICALLS.ws_url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    //Connect websocket
    socket.connect();

    // if the web socketis connected
    socket.onConnect((data) {
      //get last messages
      getMessages(userID.toString());
    });

    socket.onConnectError((data) {
      print("error");
      print(data);
    });
  }

  void getMessages(String userId) {
    socket.emit('getMessageListing', {'userId': userId});
    socket.on('getListingResponse', (data) {

      var chatsArr = data['data'];

      users.value = List<UserChat>.from(chatsArr
          .map((dynamic message) => UserChat.fromJson(message))
          .toList());

      for (UserChat user in users) {
        total_unread_messages = total_unread_messages + user.unReadCount;
      }

      usersTemp = List<UserChat>.from(users.value);


      /*for (int i = 0; i < chatsArr.length; i++) {
        setMessageResponse(chatsArr[i]);
      }*/
    });
  }

  void setMessageResponse(dynamic message) {
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


  serachMessages(String name) {

    if (name.isEmpty) {
      users.value = usersTemp;
    } else {
      users.value = usersTemp
          .where((element) =>
          element.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }

  }

}
