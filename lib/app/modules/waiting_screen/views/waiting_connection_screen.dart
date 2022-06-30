import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/modules/waiting_screen/controllers/waiting_connection_screen_controller.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/widgets/button.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

import '../../../data/api_calls.dart';
import '../../../data/http_manager.dart';
import '../../../data/models/request/connection_request_model.dart';
import '../../../widgets/snack_bar.dart';
import '../../home/views/home_view.dart';

class WaitingScreenView extends GetView<WaitingConnectionScreenController> {
  String? connectionID;

  WaitingScreenView({this.connectionID});

  final controller = Get.put(WaitingConnectionScreenController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: SimpleAppBar(backButton: true),
      body: FutureBuilder<ConnectionResponseModel>(
          future: controller.getWaitingConnection(connectionID!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: pluhgProgress());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                ConnectionResponseModel responseData = snapshot.data!;
                var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                    .parseUTC(responseData.createdAt!)
                    .toLocal();
                String formattedDate =
                DateFormat("dd MMM yyyy hh:mm").format(dateValue);
                return CustomScrollView(
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
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
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
                                                    BorderRadius.circular(
                                                        15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              5, 0, 0, 0),
                                                          blurRadius: 20)
                                                    ]),
                                                child: cardProfile2(
                                                    context,
                                                    responseData.userId!,
                                                    responseData.requester!,
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
                                                      blurRadius: 20,
                                                    )
                                                  ]),
                                              child: cardProfile2(
                                                  context,
                                                  responseData.userId!,
                                                  responseData.contact!,
                                                  "Contact"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(width: 20.w),
                                    Expanded(
                                        child: PlugByWidgetCard(
                                            userName:
                                            responseData.userId?.userName ==
                                                null
                                                ? "Pluhg user"
                                                : "@" +
                                                (responseData.userId
                                                    ?.userName ??
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
                                          backgroundImage: NetworkImage(
                                              APICALLS.imageBaseUrl +
                                                  (responseData.userId
                                                      ?.profileImage ??
                                                      ""))),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      (responseData.userId?.userName == null
                                          ? (responseData.userId?.userName ??
                                          "")
                                          : "Message From \n" +
                                          "@" +
                                          (responseData.userId?.userName ??
                                              "")),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff575858)),
                                    ),
                                  ],
                                ),
                                if (responseData.both != null &&
                                    responseData.both != "")
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Text(
                                      "${responseData.both}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                if (controller.isRequester.value &&
                                    responseData.requester?.message != null &&
                                    responseData.requester?.message != "")
                                  Container(
                                    //width: 307.22,
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Text(
                                      "${responseData.requester?.message}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                if (!controller.isRequester.value &&
                                    responseData.contact?.message != null &&
                                    responseData.contact?.message != "")
                                  Container(
                                    //width: 307.22,
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Text(
                                      "${responseData.contact?.message}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //ADD HERE
                                      },
                                      child: smallCard(
                                          responseData.userId!,
                                          responseData.requester!,
                                          responseData.isRequesterAccepted),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: smallCard(
                                          responseData.userId!,
                                          responseData.contact!,
                                          responseData.isRequesterAccepted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          (controller.isRequester.value && (responseData
                              ?.isRequesterAccepted ?? false)) ?
                          Container(
                            margin: EdgeInsets.only(
                              top: 12.0.h,
                              left: 24.0.w,
                              right: 24.0.w,
                              bottom: 12.h,
                            ),
                            padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFFA4A4A4),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: Text(
                                _getUserName(responseData, controller.isRequester.value),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ) : (!controller.isRequester.value && (responseData
                              ?.isContactAccepted ?? false))
                              ? Container(
                            margin: EdgeInsets.only(
                              top: 12.0.h,
                              left: 24.0.w,
                              right: 24.0.w,
                              bottom: 12.h,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFFA4A4A4),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: Text(
                                _getUserName(responseData, controller.isRequester.value),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ) : Visibility(
                            visible: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: button3("Accept", pluhgGreenColour),
                                  onTap: () async {
                                    HTTPManager()
                                        .acceptConnection(
                                        ConnectionRequestModel(
                                            connectionId: connectionID))
                                        .then((value) {
                                      showPluhgDailog2(
                                        Get.context!,
                                        "Success",
                                        "Accepted Successfully"!,
                                        onCLosed: () {
                                          print(
                                              "[Dialogue:OnClose] go to HomeView [2]");
                                          if (value.isRequesterAccepted! &&
                                              value.isContactAccepted!) {
                                            Get.offAll(() =>
                                                HomeView(
                                                  index: 2,
                                                ));
                                          } else {
                                            Get.offAll(() =>
                                                HomeView(
                                                  index: 0,
                                                  connectionTabIndex: 1,
                                                ));
                                          }
                                        },
                                      );
                                    }).catchError((onError) {
                                      pluhgSnackBar(
                                          'Sorry', onError.toString());
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: button3("Decline", Colors.red),
                                  onTap: () async {
                                    HTTPManager()
                                        .declineConnection(
                                        ConnectionRequestModel(
                                            connectionId:
                                            connectionID ?? "",
                                            reason: 'Unknown ??'))
                                        .then((value) {
                                      showPluhgDailog2(
                                        Get.context!,
                                        "Success",
                                        value.message!,
                                        onCLosed: () {
                                          print(
                                              "[Dialogue:OnClose] go to HomeView [2]");
                                          Get.offAll(() =>
                                              HomeView(
                                                  index: 0,
                                                  connectionTabIndex: 1));
                                        },
                                      );
                                    }).catchError((onError) {
                                      pluhgSnackBar(
                                          'Sorry', onError.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: size.width * 0.1),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Text('') //Text('${snapshot.data.message}'),
                );
              }
            } else {
              return SizedBox.shrink();
            }
          }),
    );
  }
}

String _getUserName(ConnectionResponseModel data, bool isRequester) {
  String initials = "You've Accepted. Waiting on ";
  if (isRequester) {
    if (data.contact?.refId?.userName?.isNotEmpty ?? false) {
      return "$initials${data.contact?.refId?.userName}";
    } else {
      return "$initials${data.userId?.userName}'s Contact";
    }
  } else {
    if (data.requester?.refId?.userName?.isNotEmpty ?? false) {
      return "$initials${data.requester?.refId?.userName}";
    } else {
      return "$initials${data.userId?.userName}'s Contact";
    }
  }
}