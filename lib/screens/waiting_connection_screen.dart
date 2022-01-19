import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:plug/app/values/strings.dart';
import 'package:plug/app/widgets/search_app_bar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/widgets/button.dart';
import 'package:plug/widgets/colours.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color primaryColor = Color(0xFF000BFF);

class WaitingConnectionScreen extends StatefulWidget {
  final dynamic data;

  const WaitingConnectionScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _WaitingConnectionScreenState createState() =>
      _WaitingConnectionScreenState();
}

class _WaitingConnectionScreenState extends State<WaitingConnectionScreen>
    with SingleTickerProviderStateMixin {
  late var data;
  String? userID;
  String? email;
  String? phone;
  late bool isRequester;
  bool _responded = false;

  getUserID() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    setState(() {
      userID = pres.getString(prefuserid);
      email = pres.getString(prefuseremail);
      phone = pres.getString(prefuserphone);
    });
    isRequester = userID != null && data["requester"]["_id"] == userID;
  }

  @override
  void initState() {
    _responded = false;
    data = widget.data;
    super.initState();

    getUserID();
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
        appBar: SimpleAppBar(
          backButton: true,
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
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
                        horizontal: 16.w, vertical: size.width * 0.026),
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height: 151.72.h,
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
                                        height: 151.72.h,
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
                            Container(width: 20.w),
                            Expanded(
                                child: PlugByWidgetCard(
                                    userName: data['userId']["userName"] == null
                                        ? data['userId']["name"]
                                        : "@" + data['userId']["userName"],
                                    date: formattedDate))
                          ],
                        ),
                        SizedBox(
                          height: 14.79,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 39,
                              height: 45,
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      APICALLS.imageBaseUrl +
                                          data['userId']['profileImage']
                                              .toString())),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Message From \n" +
                                  (data['userId']["userName"] == null
                                      ? data['userId']["name"]
                                      : "@" + data['userId']["userName"]),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff575858)),
                            ),
                          ],
                        ),
                        Container(
                          //width: 307.22,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Text(
                            data["requester"]["message"] == "" ||
                                    data["requester"]["message"] == null
                                ? "Hi!! You have been connected, please check the app"
                                : "${data["requester"]["message"]}",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 14.79,
                        ),
                      ],
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
                            GestureDetector(
                              onTap: () {
                                //ADD HERE
                              },
                              child: smallCard(data["requester"]["refId"],
                                  data["isRequesterAccepted"]),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: smallCard(data["contact"]["refId"],
                                  data["isContactAccepted"]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  userID != null && !_responded
                      ? Visibility(
                          // visible:
                          // isRequester
                          //     ? !data["isRequesterAccepted"]
                          //     : !data["isContactAccepted"],
                          visible: _responded ? false : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: button3("Accept", pluhgGreenColour),
                                onTap: () async {
                                  APICALLS apicalls = APICALLS();
                                  var d = data["requester"]["refId"]["_id"];
                                  bool _isSuccessful =
                                      await apicalls.respondToConnectionRequest(
                                          isContact: data["contact"]["refId"]
                                                      ["_id"] ==
                                                  userID
                                              ? true
                                              : false,
                                          connectionID: data["_id"],
                                          contact: email!,
                                          context: context,
                                          plugID: data["userId"]["_id"],
                                          isAccepting: true,
                                          isRequester: data["requester"]
                                                      ["refId"]["_id"] ==
                                                  userID
                                              ? true
                                              : false);
                                  setState(() {
                                    _responded = _isSuccessful;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                child: button3("Decline", Colors.red),
                                onTap: () async {
                                  APICALLS apicalls = APICALLS();
                                  bool _isSuccessful =
                                      await apicalls.respondToConnectionRequest(
                                          connectionID: data["_id"],
                                          contact: email!,
                                          context: context,
                                          plugID: data["userId"]["_id"],
                                          isAccepting: false,
                                          isContact: data["contact"]["refId"]
                                                      ["_id"] ==
                                                  userID
                                              ? true
                                              : false,
                                          isRequester: data["requester"]
                                                      ["refId"]["_id"] ==
                                                  userID
                                              ? true
                                              : false);
                                  setState(() {
                                    _responded = _isSuccessful;
                                  });
                                  // if (_isSuccessful) {
                                  //   Navigator.pop(context);
                                  // }
                                },
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
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
