import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/widgets/button.dart';
import 'package:plug/widgets/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/chat_screen.dart';

Color primaryColor = Color(0xFF000BFF);

class ActiveConnectionScreen extends StatefulWidget {
  final dynamic data;
  final bool isRequester;

  const ActiveConnectionScreen({
    Key? key,
    required this.data,
    required this.isRequester,
  }) : super(key: key);

  @override
  _ActiveConnectionScreenState createState() => _ActiveConnectionScreenState();
}

class _ActiveConnectionScreenState extends State<ActiveConnectionScreen>
    with SingleTickerProviderStateMixin {
  late dynamic data;

  @override
  void initState() {
    data = null;
    data = widget.data;
    print(data);
    super.initState();
    getUserID();
  }

  String? userID;

  getUserID() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    setState(() {
      userID = pres.getString("userID");
    });
  }

  @override
  Widget build(BuildContext context) {
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parseUTC(data["created_at"])
        .toLocal();
    String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffF3F9FF),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xffF3F9FF),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 56),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 56,
              child: Text(
                "${data["userId"]["userName"]} Pluhgged",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: pluhgColour,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: size.width * 0.06),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.048,
                          vertical: size.width * 0.048),
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      decoration: BoxDecoration(
                        color: Color(0xffEBEBEB),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          height: size.width * 0.352,
                                          width: size.width * 0.234,
                                          padding: EdgeInsets.all(
                                              size.width * 0.0266),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        5, 0, 0, 0),
                                                    blurRadius: 20)
                                              ]),
                                          child: Column(
                                            children: [
                                              !data["requester"]["refId"]
                                                          .containsKey(
                                                              "profileImage") ||
                                                      data["requester"]["refId"]
                                                              [
                                                              "profileImage"] ==
                                                          null
                                                  ? Container(
                                                      width: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      height: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          "resources/svg/profile.svg",
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: pluhgColour,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                    )
                                                  : Container(
                                                      width: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      height: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: pluhgColour,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15)),
                                                      child: Center(
                                                          child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "${APICALLS.url}/uploads/${data["requester"]["refId"]['profileImage'].toString()}"),
                                                      ))),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              data["requester"].containsKey(
                                                          "userName") &&
                                                      data["requester"]
                                                              ["userName"] !=
                                                          null
                                                  ? Expanded(
                                                      child: Text(
                                                          "@${data["requester"]["userName"]}",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff8D8D8D),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          textAlign:
                                                              TextAlign.center),
                                                    )
                                                  : Expanded(
                                                      child: Text(
                                                          "@${data["requester"]["name"]}",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff8D8D8D),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                "Requester",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Container(
                                          height: size.width * 0.352,
                                          width: size.width * 0.234,
                                          padding: EdgeInsets.all(
                                              size.width * 0.0266),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        5, 0, 0, 0),
                                                    blurRadius: 20)
                                              ]),
                                          child: Column(
                                            children: [
                                              !data["contact"]["refId"]
                                                          .containsKey(
                                                              "profileImage") ||
                                                      data["contact"]["refId"][
                                                              "profileImage"] ==
                                                          null
                                                  ? Container(
                                                      width: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      height: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                            "resources/svg/profile.svg"),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: pluhgColour,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                    )
                                                  : Container(
                                                      width: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      height: size.width *
                                                              0.234 -
                                                          size.width * 0.0532,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: pluhgColour,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Center(
                                                          child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "APICALLS.url/uploads/${data["contact"]["refId"]['profileImage'].toString()}"),
                                                      ))),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              data["contact"].containsKey(
                                                          "userName") &&
                                                      data["contact"]
                                                              ["userName"] !=
                                                          null
                                                  ? Expanded(
                                                      child: Text(
                                                          "@${data["contact"]["userName"]}",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff8D8D8D),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          textAlign:
                                                              TextAlign.center),
                                                    )
                                                  : Expanded(
                                                      child: Text(
                                                          "@${data["contact"]["name"]}",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff8D8D8D),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                "Contact",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              )
                                            ],
                                          )),
                                      // cardProfile2(context,
                                      //     data["contact"], "Contact")),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 9.4,
                                    ),
                                    Text("Plugged by:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xff898B8B),
                                            fontSize: 10)),
                                    Text(
                                      "@${data['userId']["userName"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xff575858)),
                                    ),
                                    SizedBox(height: 4.71),
                                    Text(
                                      "Date:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xff898B8B),
                                          fontSize: 10),
                                    ),
                                    Text(
                                      formattedDate.toString().substring(0, 11),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xff575858)),
                                    ),
                                    SizedBox(height: 4.71),
                                    Text(
                                      "Time:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xff898B8B),
                                          fontSize: 10),
                                    ),
                                    Text(
                                      formattedDate.toString().substring(12),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xff575858)),
                                    ),
                                  ]),
                            ],
                          ),
                          SizedBox(
                            height: size.width * 0.053,
                          ),
                          Row(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: size.width * 0.1,
                                  height: size.width * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Image.network(
                                        "APICALLS.url/uploads/${data['userId']['profileImage'].toString()}"),
                                  )),
                              SizedBox(
                                width: size.width * 0.026,
                              ),
                              Text(
                                "Meesage From @${data["userId"]["userName"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: size.width * 0.034,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff575858)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.width * 0.02,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(size.width * 0.03),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Text(
                              data["requester"]["message"] == ""
                                  ? "Hi!! You have been connected, please check the app"
                                  : "${data["requester"]["message"]}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.width * 0.05,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    data["requester"]["refId"]["_id"] != userID
                        ? Container()
                        : GestureDetector(
                            child: button3("Close Connection", pluhgRedColour),
                            onTap: () async {
                              APICALLS apicall = APICALLS();
                              bool _isSuccessfull =
                                  await apicall.closeConnection(
                                      context: context,
                                      connectionID: data["_id"]);
                            },
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: button4(
                          Icon(
                            CupertinoIcons.chat_bubble_2,
                            color: pluhgColour,
                          ),
                          "Conversation",
                          pluhgColour),
                      onTap: () {
                        //needs senderID and recieverID
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      username_receiver: !widget.isRequester
                                          ? "@${data["requester"]["userName"]}"
                                          : "@${data["contact"]["userName"]}",
                                      name_receiver: !widget.isRequester
                                          ? data["requester"]["name"]
                                          : data["contact"]["name"],
                                      profile_receiver:
                                          "${APICALLS.imageBaseUrl}${!widget.isRequester ? data["requester"]["refId"]['profileImage'] : data["contact"]["refId"]['profileImage'].toString()}",
                                      senderId: widget.isRequester
                                          ? data["requester"]["refId"]["_id"]
                                          : data["contact"]["refId"]["_id"],
                                      recevierId: !widget.isRequester
                                          ? data["requester"]["refId"]["_id"]
                                          : data["contact"]["refId"]["_id"],
                                    )));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {Key? key, required this.size, required this.isMe, required this.image})
      : super(key: key);

  final Size size;
  final bool isMe;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe
            ? SizedBox()
            : image == null
                ? Image.asset(
                    "resources/null_connection_image.png",
                    height: size.width * 0.12,
                    width: size.width * 0.12,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                        "APICALLS.url/uploads/$image"),
                    radius: size.width * 0.06,
                  ),
        SizedBox(
          width: size.width * 0.025,
        ),
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(size.width * 0.05),
                  topLeft:
                      isMe ? Radius.circular(size.width * 0.05) : Radius.zero,
                  bottomLeft: Radius.circular(size.width * 0.05),
                  bottomRight:
                      isMe ? Radius.zero : Radius.circular(size.width * 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      spreadRadius: 0)
                ],
              ),
              padding: EdgeInsets.all(size.width * 0.0375),
              child: Text(
                "What's Up, How are you?",
                style: TextStyle(
                  fontFamily: "Muli",
                  fontWeight: FontWeight.w600,
                  fontSize: size.width * 0.035,
                  color: isMe ? Colors.white : Color(0xFF707070),
                ),
              ),
            ),
            SizedBox(
              height: size.width * 0.025,
            ),
            Opacity(
              opacity: 0.4,
              child: Text(
                "12:13 AM",
                style: TextStyle(
                  fontFamily: "Muli",
                  fontSize: size.width * 0.03,
                  color: Color(0xFF707070),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
//{data["requester"]['profileImage'].toString()}
