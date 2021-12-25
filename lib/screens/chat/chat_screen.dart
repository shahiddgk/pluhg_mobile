import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/screens/chat/chat_appbar.dart';
import 'package:plug/screens/chat/input_chat_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../widgets/chat_widgets.dart';
import '../../../widgets/header.dart';
import '../../../widgets/models/message.dart';
import '../../../widgets/text_style.dart';

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

  void connect() {
    socket = IO.io("http://143.198.187.200:3001", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) {
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

    });
    print(socket.connected);
  }

  void sendMessage(
    String message,
    String senderId,
    String recevierId,
    String messageType,
  ) {
    try {
      setMessage('source', message, messageType);
      socket.emit('sendMessage', {
        'message': message,
        'messageType': messageType,
        'senderId': senderId,
        'recevierId': recevierId,
      });
    } catch (e) {
      print(e);
    }
  }

  void setMessage(String type, dynamic message, String messageType) {
    Message messageModel = Message(
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
    messages.add(
      Message(
        id: message['_id'].toString(),
        messageType: message['messageType'],
        message: message['message'],
        // time: message['createdAt'].toString(),
        // date: message['createdAt'].toString(),

        time: DateFormat('hh:mm a').format(message['createdAt']).toString(),
        date:
            DateFormat('dd MMMM, yyyy').format(message['createdAt']).toString(),
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

  send_message(String text){
    sendMessage(
      text,
      widget.senderId,
      widget.recevierId,
      'text',
    );
    _controller.clear();
  }

  send_document() async{
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<String> files =
      result.paths.map((path) => path!).toList();
      // files.forEach((element) {
      //   print(element.absolute);
      // });
      APICALLS apicalls = APICALLS();
      var response = await apicalls.uploadFile(widget.senderId, files);
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
      bottomSheet:
          InputChatWidget(send_function: send_message, send_doc: send_document) /*Container(
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
                      // USE url = http://143.198.187.200:3001/uploads/messages[i].message to preview files
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
                    // USE url = http://143.198.187.200:3001/uploads/messages[i].message to preview files
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
                            img: "person2"),
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
