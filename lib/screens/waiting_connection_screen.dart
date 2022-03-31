import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/widgets/button.dart';
import 'package:plug/widgets/colours.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

Color primaryColor = Color(0xFF000BFF);

class WaitingConnectionScreen extends StatefulWidget {
  final dynamic data;

  const WaitingConnectionScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _WaitingConnectionScreenState createState() => _WaitingConnectionScreenState();
}

class _WaitingConnectionScreenState extends State<WaitingConnectionScreen> with SingleTickerProviderStateMixin {
  late var data;

  User? user;
  bool _responded = false;
  final APICALLS api = APICALLS();

  Future<void> getUserID() async {
    User currentUser = await UserState.get();
    setState(() {
      user = currentUser;
    });
  }

  @override
  void initState() {
    _responded = false;
    super.initState();

    data = widget.data;

    getUserID().then((_) {
      bool responded = false;
      final requesterContact = data["requester"]["contact"];

      if (user?.email == requesterContact || user?.phone == requesterContact) {
        responded = data["isRequesterAccepted"];
      } else {
        responded = data["isContactAccepted"];
      }

      setState(() {
        _responded = responded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(widget.data["created_at"]).toLocal();
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: size.width * 0.026),
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
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [BoxShadow(color: Color.fromARGB(5, 0, 0, 0), blurRadius: 20)]),
                                        child: cardProfile2(context, widget.data["requester"]["refId"], "Requester")),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      height: 151.72.h,
                                      width: 87.2,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(5, 0, 0, 0),
                                              blurRadius: 20,
                                            )
                                          ]),
                                      child: cardProfile2(context, widget.data["contact"]["refId"], "Contact"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(width: 20.w),
                            Expanded(
                                child: PlugByWidgetCard(
                                    userName: widget.data['userId']["userName"] == null
                                        ? widget.data['userId']["name"]
                                        : "@" + widget.data['userId']["userName"],
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
                                  backgroundImage: CachedNetworkImageProvider(
                                      APICALLS.imageBaseUrl + widget.data['userId']['profileImage'].toString())),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Message From \n" +
                                  (widget.data['userId']["userName"] == null
                                      ? widget.data['userId']["name"]
                                      : "@" + widget.data['userId']["userName"]),
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff575858)),
                            ),
                          ],
                        ),
                        Container(
                          //width: 307.22,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                          child: Text(
                            widget.data["requester"]["message"] == "" || widget.data["requester"]["message"] == null
                                ? "Hi!! You have been connected, please check the app"
                                : "${widget.data["requester"]["message"]}",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
                    decoration: BoxDecoration(color: Color(0xffEBEBEB), borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Connection Status:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                //ADD HERE
                              },
                              child: smallCard(widget.data["requester"]["refId"], widget.data["isRequesterAccepted"]),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: smallCard(widget.data["contact"]["refId"], widget.data["isContactAccepted"]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  this.user != null && !_responded
                      ? Visibility(
                          // visible:
                          // isRequester
                          //     ? !widget.data["isRequesterAccepted"]
                          //     : !widget.data["isContactAccepted"],
                          visible: _responded ? false : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: button3("Accept", pluhgGreenColour),
                                onTap: () async {
                                  bool _isSuccessful = await this.api.acceptConnectionRequest(
                                        context: context,
                                        connectionID: widget.data["_id"],
                                      );
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
                                  bool _isSuccessful = await this.api.declineConnectionRequest(
                                        context: context,
                                        connectionID: widget.data["_id"],
                                        reason: "Unknown ??",
                                      );
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
              child: SizedBox(height: size.width * 0.1),
            ),
          ],
        ));
  }
}
