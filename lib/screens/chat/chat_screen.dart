import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/models/file_model.dart';
import 'package:plug/screens/chat/chat_widgets/chat_appbar.dart';
import 'package:plug/screens/chat/chat_widgets/chat_bubble.dart';
import 'package:plug/screens/chat/media_options/dialog_options_android.dart';
import 'package:plug/screens/chat/chat_widgets/input_chat_widget.dart';
import 'package:plug/screens/chat/media_options/multi_document_picker.dart';
import 'package:plug/screens/chat/media_options/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../widgets/chat_widgets.dart';
import '../../../widgets/header.dart';
import '../../../widgets/models/message.dart';
import '../../../widgets/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key,
      required this.name_receiver,
      required this.profile_receiver,
      required this.username_receiver,
      required this.senderId,
      required this.recevierId})
      : super(key: key);
  final String username_receiver;

  final String name_receiver;
  final String profile_receiver;
  final String senderId;
  final String recevierId;

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myid = prefs.getString(prefuserid).toString();
  }

  @override
  void initState() {
    super.initState();
    connect();
    getMyId();
  }

  @override
  void dispose() {
    super.dispose();
    // socket.close();
  }

  void connect() {
    socket = IO.io("ws://3.18.123.250", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    if (socket.connected == true) {
      socket.disconnect();
    }

    socket.connect();
    socket.onConnect((data1) {
      getMessages(widget.senderId, widget.recevierId);
      socket.on('sendMessageResponse', (msg) {
        print('**************');
        print(msg['data']);
        setMessageResponse(msg['data']);
      });
      socket.on('readMessageResponse', (data) {
        /* messages.forEach((element) {

          print("---------------------------------------------------------------");
          print(data["data"]["senderId"] );
          if (element.id == data['data']['_id']) {
            var message = data['data'];
            setState(() {
              element = Message(
                senderId:message["senderId"] ,
                image: "${APICALLS.url}/uploads/" +
                    message["senderId"]["profileImage"],
                id: message['_id'].toString(),
                messageType: message['messageType'],
                message: message['message'],
                time: DateFormat('hh:mm a')
                    .format(message['createdAt'])
                    .toString(),
                date: DateFormat('dd MMMM, yyyy')
                    .format(message['createdAt'])
                    .toString(),
                type: message['senderId'] == myid ? 'source' : 'destination',
                isRead: message['isRead'],
                isDeleted: message['isDeleted'],
              );
            });
          }
        });*/
      });
    });
    socket.onConnectError((data) {
      print("error");
      print(data);
    });
  }

  void sendMessage_type(String text, String senderId, String recevierId,
      String messageType, List<FileModel> files) async {
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

    // try {
    setMessage('source',
        messageType == "text" ? text : json.encode(res_files_name), messageType,
        files: res_files_name);

    socket.emit('sendMessage', {
      'message': messageType == "text" ? text : json.encode(res_files_name),
      'messageType': messageType,
      'senderId': myid,
      'recevierId': myid == recevierId ? senderId : recevierId,
    });

    _controller_s.jumpTo(_controller_s.position.maxScrollExtent + 100.h);
    FocusScope.of(context).unfocus();
  }

  void setMessage(String type, dynamic message, String messageType,
      {List<String>? files}) {
    Message messageModel = Message(
      senderId: myid,
      type: type,
      message: message,
      time: DateFormat('hh:mm a').format(DateTime.now()).toString(),
      date: DateFormat('dd MMMM, yyyy').format(DateTime.now()).toString(),
      isRead: false,
      isDeleted: false,
      messageType: messageType,
    );
    setState(() {
      messages.add(messageModel);
    });
  }

  void setMessageResponse(dynamic message) {
    if (!this.mounted) return;

    setState(() {
      //message.add(Message.fromJson(message, myid));
    });

    //"${APICALLS.url}/uploads/" + message["senderId"]["profileImage"]
    /*messages.add(
      Message(
        image: "",
        id: message['_id'].toString(),
        messageType:
            message['messageType'] == null ? "text" : message['messageType'],
        message: message['messageType'] == null ? "" : message['message'],
        // time: message['createdAt'].toString(),
        // date: message['createdAt'].toString(),

        time: DateFormat('hh:mm a')
            .format(DateTime.parse(message['createdAt']))
            .toString(),
        date: DateFormat('dd MMMM, yyyy')
            .format(DateTime.parse(message['createdAt']))
            .toString(),
        type: message['senderId'] == myid ? 'source' : 'destination',
        isRead: message['receiverId'] == myid ? true : message['isRead'],
        isDeleted: message['isDeleted'],
      ),
    );*/
  }

  void getMessages(String userId, String oppUserId) {
    socket.emit('getUserMessage', {
      'userId': userId,
      'oppUserId': oppUserId,
    });
    socket.on('getUserMessageResponse', (data) {
      if (!this.mounted) return;
      var messagesArr = data['data'];

      for (int i = 0; i < messagesArr.length; i++) {
        if (messagesArr[i]['recevierId'] == myid) {
          socket.emit('/readMessage', {
            'userId': myid,
            'messageId': messagesArr[i]['_id'],
          });
        }
      }

      setState(() {
        messages = List<Message>.from(
            messagesArr.map((e) => Message.fromJson(e, myid)).toList());
        loading = false;
        new Timer(const Duration(milliseconds: 1000), () {
          _controller_s.jumpTo(_controller_s.position.maxScrollExtent + 100.h);
        });
      });
    });
  }

  send_message(String text, type) {
    sendMessage_type(text, widget.senderId, widget.recevierId, type, []);
    _controller.clear();
  }

  send_document() {
    /* if (Platform.isIOS) {
      final action = CupertinoActionSheet(
        title: Text(
          "Flutter Agency",
          style: TextStyle(fontSize: 30),
        ),
        message: Text(
          "Select your action ",
          style: TextStyle(fontSize: 15.0),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("First Action"),
            isDefaultAction: true,
            onPressed: () {
              print("First Action is clicked ");
            },
          ),
          CupertinoActionSheetAction(
            child: Text(" Second Action"),
            isDestructiveAction: true,
            onPressed: () {
              print("Second Action clicked");
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
      showCupertinoModalPopup(context: context, builder: (context) => action);
    } else {*/

    showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.all(12.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                  padding: EdgeInsets.all(4),
                  height: 200.h,
                  width: 240.w,
                  child: DialogOptionsAndroid(
                      send_camera_image: () {},
                      send_document: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiDocumentPicker(
                                      title: "Select File",
                                      callback: upload_document,
                                      writeMessage:
                                          (String? url, int time) async {
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
                                      writeMessage:
                                          (String? url, int time) async {
                                        if (url != null) {
                                          ///send message
                                        }
                                      },
                                    )));
                      })));
        });
  }

  upload_document(type, subType, files) async {
    APICALLS apicalls = APICALLS();
    var response =
        await apicalls.uploadFile(widget.senderId, files, type, subType);

    sendMessage_type(
        "",
        myid,
        myid == widget.recevierId ? widget.senderId : widget.recevierId,
        subType,
        response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(widget.profile_receiver, widget.name_receiver,
          widget.username_receiver),
      bottomSheet:
          InputChatWidget(send_function: send_message, send_doc: send_document),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            loading
                ? Center(child: CupertinoActivityIndicator())
                : Expanded(
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.7,
                      padding: EdgeInsets.all(15),
                      child: ListView.builder(
                        controller: _controller_s,
                        itemCount: messages.length,
                        itemBuilder: (ctx, i) {
                          /* if (messages[i].type == 'source') {
                      // USE url = APICALLS.url/uploads/messages[i].message to preview files
                      if (messages[i].messageType == 'image')
                        return Container(
                          height: 50,
                          width: 100,
                          child: Text(messages[i].message),
                        );
                      if (messages[i].messageType == 'video')
                        return Container(
                          height: 50,
                          width: 100,
                          child: Text(messages[i].message),
                        );
                      if (messages[i].messageType == 'gif')
                        return Container(
                          height: 50,
                          width: 100,
                          child: Text(messages[i].message),
                        );
                      if (messages[i].messageType == 'pdf')
                        return Container(
                          height: 50,
                          width: 100,
                          child: Text(messages[i].message),
                        );
                      if (messages[i].messageType == 'xls' ||
                          messages[i].messageType == 'xlsx')
                        return Container(
                          height: 50,
                          width: 100,
                          child: Text(messages[i].message),
                        );
                      if (messages[i].messageType == 'doc' ||
                          messages[i].messageType == 'docx')
                        return Container(
                          height: 50,
                          width: 100,
                          child: Text(messages[i].message),
                        );
                      if (messages[i].messageType == 'text')
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: myMessage(
                            context: context,
                            message: messages[i].message,
                            time: messages[i].time,
                          ),
                        );
                    }
                    // USE url = APICALLS.url/uploads/messages[i].message to preview files
                    if (messages[i].messageType == 'image') return Container();
                    if (messages[i].messageType == 'video') return Container();
                    if (messages[i].messageType == 'gif') return Container();
                    if (messages[i].messageType == 'pdf') return Container();
                    if (messages[i].messageType == 'xls' ||
                        messages[i].messageType == 'xlsx') return Container();
                    if (messages[i].messageType == 'doc' ||
                        messages[i].messageType == 'doc') return Container();
                    if (messages[i].messageType == 'text')
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: recieverMessage(
                            context: context,
                            message: messages[i].message,
                            time: messages[i].time,
                            img: ""

                            ///jijiji
                            ),
                      );*/

                          return BubbleChat(messages[i],
                              isMe:
                                  myid == messages[i].senderId ? true : false);
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
    );
  }
}
