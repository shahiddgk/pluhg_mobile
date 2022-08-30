import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/chat_screen/chat/chat_widgets/input_chat_widget.dart';
import 'package:plug/app/modules/chat_screen/chat/dialog_options_android.dart';
import 'package:plug/app/modules/chat_screen/chat/media_options/multi_document_picker.dart';
import 'package:plug/app/modules/chat_screen/chat/media_options/multi_image_picker.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/models/file_model.dart';
import 'package:plug/widgets/models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'chat_widgets/chat_appbar.dart';
import 'chat_widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key,
      required this.name_receiver,
      required this.profile_receiver,
      required this.username_receiver,
      required this.senderId,
      required this.recevierId, this.clearUnReadMessageCount,
      })
      : super(key: key);
  final String username_receiver;

  final String name_receiver;
  final String profile_receiver;
  final String senderId;
  final String recevierId;
  final VoidCallback? clearUnReadMessageCount;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Message> messages = [];
  TextEditingController _controller = TextEditingController();
  late String myid = "";
  late bool loading = true;
  final ScrollController _controller_s = ScrollController();

  getMyId() async {
    // get user's id from shared preferences
    User user = await UserState.get();
    this.myid = user.id;
    print("[ChatScreen::getMyId] ${this.myid}");
  }

  @override
  void initState() {
    super.initState();
    getMyId();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
    // socket.close();
  }

  void setMessageResponse(dynamic message) {
    if (!this.mounted) return;

    setState(() {
      messages.insert(0, Message.fromJson2(message["data"], myid, message["data"]["senderDetails"]["_id"]));
    });
  }

  void connect() {
    socket = IO.io(
        "${APICALLS.ws_url}",
        OptionBuilder()
            .setTransports(['websocket'])
            // .enableAutoConnect()
            // .enableForceNewConnection()
            .enableForceNewConnection()
            .disableAutoConnect()
            .setQuery(<String, dynamic>{'room': 'test'})
            .build());

    if (socket.connected == true) {
      socket.disconnect();
    }

    //connect websocket
    socket.connect();
    socket.onConnect((data1) {
      getMessages(widget.senderId, widget.recevierId);
      socket.on('sendMessageResponse', (msg) {
        print('[sendMessageResponse] new message: ${msg.toString()}');
        setMessageResponse(msg);
      });

      socket.on('readMessageResponse', (data) {

        print('[readMessageResponse] read message: ${data.toString()}');

        messages.forEach((element) {
          print("[readMessageResponse] element ID [${element.id.toString()}] ");
          if (element.id == data['_id']) {
            // var message = data['data'];
            // setState(() {
            //   element = Message(
            //     senderId: message["senderId"],
            //     // image: "${APICALLS.url}/uploads/" + message["senderId"]["profileImage"],
            //     id: message['_id'].toString(),
            //     messageType: message['messageType'],
            //     message: message['message'],
            //     time: DateFormat('hh:mm a').format(message['createdAt']).toString(),
            //     date: DateFormat('dd MMMM, yyyy').format(message['createdAt']).toString(),
            //     type: message['senderId'] == myid ? 'source' : 'destination',
            //     isRead: message['isRead'],
            //     isDeleted: message['isDeleted'],
            //   );
            // });
          }
        });
      });

      if(widget.clearUnReadMessageCount != null) {
        widget.clearUnReadMessageCount!();
      }
    });
    socket.onConnectError((data) {
      print("[onConnectError] error");
      print(data);
    });
  }

  void sendMessage_type(
      String text, String senderId, String recevierId, String messageType, List<FileModel> files) async {
    List<String> res_files_name = [];

    if (messageType == 'text')
      messageType = 'text';
    else if (messageType == "png")
      messageType = "image";
    else
      messageType = "doc";

    for (FileModel f in files) {
      res_files_name.add(f.fileName);
    }

    // setMessage('source', messageType == "text" ? text : json.encode(res_files_name), messageType,
    //     files: res_files_name);

    socket.emit('sendMessage', {
      'message': messageType == "text" ? text : json.encode(res_files_name),
      'messageType': messageType,
      'senderId': myid,
      'recevierId': myid == recevierId ? senderId : recevierId,
    });

    /* _controller_s.jumpTo(_controller_s.position.maxScrollExtent + 100.h);*/
    FocusScope.of(context).unfocus();
  }

  void getMessages(String userId, String receiverId) {
    socket.emit('getUserMessage', {
      'userId': userId,
      'receiverId': receiverId,
    });
    socket.on('getUserMessageResponse', (data) {
      if (!this.mounted) return;
      var messagesArr = data['data'];

      print("[ChatScreen:Socket:getUserMessageResponse] data: ${data.toString()}");

      // for (int i = 0; i < messagesArr.length; i++) {
      //   print(
      //       "[ChatScreen:Socket:getUserMessageResponse] readMessage: ${messagesArr[i]["chatId"]['recevierId'].toString()}");
      //   if (messagesArr[i]["chatId"]['recevierId']["_id"] == myid) {
      //     socket.emit('/readMessage', {
      //       'userId': myid,
      //       'messageId': messagesArr[i]['_id'],
      //     });
      //   }
      // }

      setState(() {
        messages = List<Message>.from(messagesArr.map((e) => Message.fromJson(e, myid)).toList()).reversed.toList();
        loading = false;
      });
    });
  }

  send_message(String text, type) {
    print("SEND MESSAGE TEST");
    sendMessage_type(text, widget.senderId, widget.recevierId, type, []);
    _controller.clear();
  }

  send_document() {
    showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.all(12.w),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                  padding: EdgeInsets.all(4),
                  height: 200.h,
                  width: 240.w,
                  child: Expanded(
                    child: DialogOptionsAndroid(
                        send_camera_image: () {},
                        send_document: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiDocumentPicker(
                                        title: "Select File",
                                        callback: upload_document,
                                        writeMessage: (String? url, int time) async {
                                          if (url != null) {
                                            ///send message
                                          }
                                        },
                                      )));
                        },
                        send_gallery_images: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiImagePicker(
                                        title: "Choose Image",
                                        callback: upload_document,
                                        writeMessage: (String? url, int time) async {
                                          if (url != null) {
                                            ///send message
                                          }
                                        },
                                      )));
                        }),
                  )));
        });
  }

  upload_document(type, subType, files) async {
    APICALLS apicalls = APICALLS();
    var response = await apicalls.uploadFile(widget.senderId, files, type, subType);

    sendMessage_type(
        "",
        myid,
        myid == widget.recevierId
            ? widget.senderId
            : widget.senderId == myid
                ? widget.recevierId
                : widget.senderId,
        subType,
        response);
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ChatAppBar(widget.profile_receiver, widget.name_receiver, widget.username_receiver),
        bottomSheet: InputChatWidget(
            send_function: send_message, send_doc: send_document,
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              loading
                  ? Center(child: pluhgProgress())
                  : Expanded(
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.7,
                        padding: EdgeInsets.all(15),
                        child: ListView.builder(
                          reverse: true,
                          controller: _controller_s,
                          itemCount: messages.length,
                          itemBuilder: (ctx, i) {
                            return BubbleChat(messages[i]);
                          },
                        ),
                      ),
                    ),
              Container(
                height: 56.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
