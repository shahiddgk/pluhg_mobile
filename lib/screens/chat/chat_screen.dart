import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/screens/chat/chat_appbar.dart';
import 'package:plug/screens/chat/dialog_options_android.dart';
import 'package:plug/screens/chat/input_chat_widget.dart';
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

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.close();
    print("yess");
  }

  void connect() {
    socket = IO.io("ws://3.18.123.250", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    print("--------------------------------------");
    print(socket.connected);
    if (socket.connected == true) {
      socket.disconnect();
    }

    socket.connect();
    socket.onConnect((data1) {
      print('Connected.');
      getMessages(widget.senderId, widget.recevierId);
      socket.on('sendMessageResponse', (msg) {
        print('**************');
        print(msg);
        setMessageResponse(msg['data']);
      });
      socket.on('readMessageResponse', (data) {
        messages.forEach((element) {
          if (element.id == data['data']['_id']) {
            var message = data['data'];
            setState(() {
              element = Message(
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
                type: message['senderId'] == widget.senderId
                    ? 'source'
                    : 'destination',
                isRead: message['isRead'],
                isDeleted: message['isDeleted'],
              );
            });
          }
        });
      });
    });
    socket.onConnectError((data) {
      print("error");
      print(data);
    });
  }

  void sendMessage(
    String message,
    String senderId,
    String recevierId,
    String messageType,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String myid = prefs.getString("userID").toString();

      setMessage('source', message, messageType);
      socket.emit('sendMessage', {
        'message': message,
        'messageType': messageType,
        'senderId': myid,
        'recevierId': myid == recevierId ? senderId : recevierId,
      });
    } catch (e) {
      print(e);
    }
  }

  void setMessage(String type, dynamic message, String messageType) {
    Message messageModel = Message(
      image: "",
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

    //"${APICALLS.url}/uploads/" + message["senderId"]["profileImage"]
    messages.add(
      Message(
        image: "",
        id: message['_id'].toString(),
        messageType: message['messageType'],
        message: message['message'],
        // time: message['createdAt'].toString(),
        // date: message['createdAt'].toString(),

        time: DateFormat('hh:mm a')
            .format(DateTime.parse(message['createdAt']))
            .toString(),
        date: DateFormat('dd MMMM, yyyy')
            .format(DateTime.parse(message['createdAt']))
            .toString(),
        type: message['senderId'] == widget.senderId ? 'source' : 'destination',
        isRead:
            message['receiverId'] == widget.senderId ? true : message['isRead'],
        isDeleted: message['isDeleted'],
      ),
    );
  }

  void getMessages(String userId, String oppUserId) {
    socket.emit('getUserMessage', {
      'userId': userId,
      'oppUserId': oppUserId,
    });
    print('getting message');
    socket.on('getUserMessageResponse', (data) {
      print(data);
      if (!this.mounted) return;
      setState(() {
// get the list of messages
        var messagesArr = data['data'];
        // messages = [];
        for (int i = 0; i < messagesArr.length; i++) {
          if (messagesArr[i]['recevierId'] == widget.senderId) {
            socket.emit('/readMessage', {
              'userId': widget.senderId,
              'messageId': messagesArr[i]['_id'],
            });
          }
          setMessageResponse(messagesArr[i]);
        }
      });
    });
  }

  send_message(String text) {
    sendMessage(
      text,
      widget.senderId,
      widget.recevierId,
      'text',
    );
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
                  child: DialogOptionsAndroid(
                      send_camera_image: () {},
                      send_document: upload_document,
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

  upload_document() async {
    print("thiiiiiiss");
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      print(result);
      List<String> files = result.paths.map((path) => path!).toList();
      print(files);
      // files.forEach((element) {
      //   print(element.absolute);
      // });
      APICALLS apicalls = APICALLS();
      var response = await apicalls.uploadFile(widget.senderId, files);
      print(
          "------------------------------------------------------------------------");
      print(response);
      response.forEach((files) {
        sendMessage(
          files['filename'],
          widget.senderId,
          widget.recevierId,
          files['mimetype'].split('/')[0],
        );
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(widget.profile_receiver, widget.name_receiver,
          widget.username_receiver),
      bottomSheet: InputChatWidget(
          send_function: send_message,
          send_doc:
              send_document) /*Container(
        height: 58,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xff000BFF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.white.withAlpha(190),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                controller: _controller,
                style: body2TextStyleWhite,
                maxLines: 200,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Yeah, I'm there.",
                    hintStyle: body2TextStyleWhite),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {

              },
              child: Image.asset("resources/attachment.png"),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {

              },
              child: Image.asset("resources/send_icon.png"),
            ),
            SizedBox(
              width: 2,
            ),
          ],
        ),
      )*/
      ,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (ctx, i) {
                    if (messages[i].type == 'source') {
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
                      );
                    return Container();
                  },
                ),
                // Container(
                //   // height: MediaQuery.of(context).size.height * 0.7,
                //   padding: EdgeInsets.all(15),
                // child: SingleChildScrollView(
                //   child: Column(
                //     children: [
                //       recieverMessage(
                //           context: context,
                //           message: "What's Up, How are you?",
                //           time: "12:13 AM",
                //           img: "person2"),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       myMessage(
                //           context: context,
                //           message: "Fine How about you",
                //           time: "12:45 AM"),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       recieverMessage(
                //           context: context,
                //           message:
                //               "unc eros accumsan nisi, quis euismod erat est id orci. bibendum accumsan ",
                //           time: "12:43 AM",
                //           img: "person2"),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       myMessage(
                //           context: context,
                //           message:
                //               " habitasse platea dictumst. condimentum risus diam, ",
                //           time: "12:45 AM"),
                //       SizedBox(
                //         height: 20,
                //       ),
                //       Text(
                //         "Today",
                //         style: body3TextStyleBlue,
                //       ),
                //       SizedBox(
                //         height: 15,
                //       ),
                //       recieverMessage(
                //           context: context,
                //           message: "???????",
                //           time: "12:54 AM",
                //           img: "person2"),
                //     ],
                //   ),
                // ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
