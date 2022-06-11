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

import '../app/data/http_manager.dart';
import '../app/data/models/request/connection_request_model.dart';
import '../app/data/models/response/connection_response_model.dart';
import '../app/widgets/snack_bar.dart';
import '../widgets/dialog_box.dart';

Color primaryColor = Color(0xFF000BFF);

class WaitingConnectionScreen extends StatefulWidget {
  final ConnectionResponseModel data;

  const WaitingConnectionScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _WaitingConnectionScreenState createState() =>
      _WaitingConnectionScreenState();
}

class _WaitingConnectionScreenState extends State<WaitingConnectionScreen>
    with SingleTickerProviderStateMixin {
  late ConnectionResponseModel data;

  User? user;
  bool _responded = false;

  //final APICALLS api = APICALLS();

  Future<void> getUserID() async {
    User currentUser = await UserState.get();
    setState(() {
      user = currentUser;
    });
  }

  bool isValueChange = false;

  @override
  void initState() {
    _responded = false;
    super.initState();

    data = widget.data;

    getUserID().then((_) {
      bool responded = false;
      final requesterContact = data.requester?.contact;

      print(data.toString());

      if (user?.email == requesterContact || user?.phone == requesterContact) {
        responded = data?.isRequesterAccepted ?? false;
      } else {
        responded = data?.isContactAccepted ?? false;
      }

      setState(() {
        _responded = responded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parseUTC(widget.data.createdAt ?? "")
        .toLocal();
    String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isValueChange);
        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: SimpleAppBar(
            backButton: true,
            onPressed: () {
              Navigator.pop(context, isValueChange);
            },
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
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.04),
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
                                              widget.data.requester!,
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
                                                color:
                                                    Color.fromARGB(5, 0, 0, 0),
                                                blurRadius: 20,
                                              )
                                            ]),
                                        child: cardProfile2(
                                            context,
                                            widget.data.contact!,
                                            "Contact"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(width: 20.w),
                              Expanded(
                                  child: PlugByWidgetCard(
                                      userName: widget.data.userId?.userName ==
                                              null
                                          ? (widget.data.userId?.name ?? "")
                                          : "@" +
                                              (widget.data.userId?.userName ??
                                                  ""),
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
                                    backgroundImage: NetworkImage(APICALLS
                                            .imageBaseUrl +
                                        (widget.data.userId?.profileImage ?? ""))),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Message From \n" +
                                    (widget.data.userId?.userName == null
                                        ? (widget.data.userId?.name ?? "")
                                        : "@" +
                                            (widget.data.userId?.userName ?? "")),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff575858)),
                              ),
                            ],
                          ),
                          if (widget.data.both != "" ||
                              widget.data.both != null)
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Text(
                                "${widget.data.both}",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                          Container(
                            //width: 307.22,
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Text(
                              widget.data.requester?.message == "" ||
                                      widget.data.requester?.message ==
                                          null
                                  ? "Hi!! You have been connected, please check the app"
                                  : "${widget.data.requester?.message}",
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
                                child: smallCard(
                                    widget.data.requester!,
                                    widget.data.isRequesterAccepted),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: smallCard(
                                    widget.data.contact!,
                                    widget.data.isContactAccepted),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 21,
                    ),

                    if (this.user != null && !_responded)
                      Visibility(
                        visible: _responded ? false : true,
                        // visible: isBottomButtonVisible,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: button3("Accept", pluhgGreenColour),
                              onTap: () async {
                                HTTPManager()
                                    .acceptConnection(ConnectionRequestModel(
                                        connectionId: widget.data.sId))
                                    .then((value) {
                                  showPluhgDailog2(
                                    context,
                                    "Success",
                                    value.message!,
                                    onCLosed: () {
                                      print(
                                          "[Dialogue:OnClose] go to HomeView [2]");
                                      // Get.offAll(() => HomeView(
                                      //     index: 2.obs,
                                      //     isDeepLinkCodeExecute: false));
                                    },
                                  );
                                }).catchError((onError) {
                                  pluhgSnackBar('Sorry', onError.toString());
                                });
                                // bool _isSuccessful =
                                //     await this.api.acceptConnectionRequest(
                                //           context: context,
                                //           connectionID: widget.data["_id"],
                                //         );
                                //
                                // if(_isSuccessful){
                                //   isValueChange = true;
                                // }
                                // setState(() {
                                //   _responded = _isSuccessful;
                                //   //isBottomButtonVisible = _isSuccessful;
                                // });
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              child: button3("Decline", Colors.red),
                              onTap: () async {
                                HTTPManager()
                                    .declineConnection(ConnectionRequestModel(
                                        connectionId: data.sId ?? "",
                                        reason: 'Unknown ??'))
                                    .then((value) {
                                  showPluhgDailog2(
                                    context,
                                    "Success",
                                    value.message!,
                                    onCLosed: () {
                                      print(
                                          "[Dialogue:OnClose] go to HomeView [2]");
                                      // Get.offAll(
                                      //         () => HomeView(index: 2.obs, isDeepLinkCodeExecute: false));
                                    },
                                  );
                                }).catchError((onError) {
                                  pluhgSnackBar('Sorry', onError.toString());
                                });
                                // bool _isSuccessful =
                                //     await this.api.declineConnectionRequest(
                                //           context: context,
                                //           connectionID: widget.data["_id"],
                                //           reason: "Unknown ??",
                                //         );
                                //
                                // if(_isSuccessful){
                                //   isValueChange = true;
                                // }
                                //
                                // setState(() {
                                //   _responded = _isSuccessful;
                                // });
                              },
                            ),
                          ],
                        ),
                      )

                    ///OLD CODE
                    /*   this.user != null && !_responded
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

                                    print('------------>$_isSuccessful');
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
                        : SizedBox(),*/
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: size.width * 0.1),
              ),
            ],
          )),
    );
  }
}
