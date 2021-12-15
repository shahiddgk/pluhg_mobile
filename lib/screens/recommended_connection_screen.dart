import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/widgets/button.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/dialog_box.dart';

Color primaryColor = Color(0xFF000BFF);

class RecommendedConnectionScreen extends StatefulWidget {
  final dynamic data;
  const RecommendedConnectionScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _RecommendedConnectionScreenState createState() =>
      _RecommendedConnectionScreenState();
}

class _RecommendedConnectionScreenState
    extends State<RecommendedConnectionScreen>
    with SingleTickerProviderStateMixin {
  late dynamic data;
  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parseUTC(data["created_at"])
        .toLocal();
    String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0, leading: Container(), backgroundColor: Colors.white),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.black),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NotificationScreenView()));
                      },
                      child: Icon(Icons.notifications_outlined,
                          color: Color(0xff080F18))),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.width * 0.05,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.026,
                        vertical: size.width * 0.026),
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 131.72,
                                          width: 87.2,
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
                                          child: cardProfile2(
                                              context,
                                              data["requester"]["refId"],
                                              "Requester")),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Container(
                                          height: 131.72,
                                          width: 87.2,
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
                                          child: cardProfile2(
                                              context,
                                              data["contact"]["refId"],
                                              "Contact")),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(children: [
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
                            height: 14.79,
                          ),
                          // data["both"].toString().isNotEmpty
                          //     ? Text("Message to both")
                          //     : Text(''),
                          // SizedBox(
                          //   height: 6,
                          // ),
                          // data["both"].toString().isNotEmpty
                          //     ? Container(
                          //         width: 307.22,
                          //         padding: EdgeInsets.all(8),
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(15),
                          //             color: Colors.white),
                          //         child: Text(
                          //           "${data["both"]}",
                          //           textAlign: TextAlign.justify,
                          //           style: TextStyle(
                          //               fontSize: 12,
                          //               fontWeight: FontWeight.w400),
                          //         ),
                          //       )
                          //     : Text(''),
                          // data["both"].toString().isNotEmpty
                          //     ? SizedBox(
                          //         height: 14.79,
                          //       )
                          //     : Text(''),
                          Text(data["requester"]["refId"]["userName"] == null
                              ? "Message to @${data["requester"]["name"]}"
                              : "Message to @${data["requester"]["refId"]["userName"]}"),
                          SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: 307.22,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Text(
                              "${data["requester"]["message"]}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            height: 14.79,
                          ),
                          Text(data["contact"]["refId"]["userName"] == null
                              ? "Message to @${data["contact"]["name"]}"
                              : "Message to @${data["contact"]["refId"]["userName"]}"),
                          SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: 307.22,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Text(
                              "${data["contact"]["message"]}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.33,
                  ),
                  Container(
                    width: 339,
                    height: 89.06,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xffEBEBEB),
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Connection Status:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            smallCard(
                                data["requester"], data["isRequesterAccepted"]),
                            smallCard(
                                data["contact"], data["isContactAccepted"]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible:
                        data["isContactAccepted"] && data["isRequesterAccepted"]
                            ? false
                            : true,
                    child: Text("Send Reminder To",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: data["isRequesterAccepted"] ? false : true,
                          child: GestureDetector(
                            onTap: () {
                              showPluhgDailog4(
                                  context, data["_id"], 'requester');
                            },
                            child: button2("Requester"),
                          ),
                        ),
                        SizedBox(
                          width: 7.05,
                        ),
                        Visibility(
                          visible: data["isContactAccepted"] ? false : true,
                          child: GestureDetector(
                            onTap: () {
                              showPluhgDailog4(context, data["_id"], 'contact');
                            },
                            child: button2("Contact"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.width * 0.1,
              ),
            ),
          ],
        ));
  }
}
