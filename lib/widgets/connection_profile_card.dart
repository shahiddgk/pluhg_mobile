import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/widgets/image.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../app/data/http_manager.dart';
import '../app/data/models/request/connection_request_model.dart';
import '../app/data/models/response/connection_response_model.dart';
import '../app/modules/home/views/home_view.dart';
import '../app/widgets/button.dart';
import '../app/widgets/colors.dart';
import '../app/widgets/snack_bar.dart';
import '../screens/chat/chat_screen.dart';
import 'dialog_box.dart';

Widget card(BuildContext context, RefId connector, Requester data,
    {bool whoIConnected = false}) {
  if (data == null) return SizedBox();

  final userName = extractUserName(connector, data, whoIConnected);
  return Column(
    children: [
      Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: cachedNetworkImageWidget(
          imageUrl: APICALLS.imageBaseUrl + (data?.refId?.profileImage ?? ""),
          height: 64.w,
          width: 64.w,
          borderRadiusValue: 12.r,
        ),
      ),
      Container(height: 2.h),
      Text(
        "$userName",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Color(0xff8D8D8D),
            fontSize: 11.sp,
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

//@todo should be a part of DTO/Model
String? extractUserName(RefId connector, Requester data, bool whoIConnected) {
  final userName = data.refId?.userName;
  final name = data.refId?.name; //data["name"];

  final isUserNameExists = userName != null && userName.isNotEmpty;
  final isContactNameExists = name != null && name.isNotEmpty;
  if (isUserNameExists) {
    return "@$userName";
  }
  if (isContactNameExists) {
    return name;
  }
  if (whoIConnected) {
    return data?.name;
  }
  return "${connector.userName}'s Contact";
}

Widget cardProfile2(
    BuildContext context, RefId connector, Requester data, String text,
    {bool whoIConnected = false}) {
  if (data == null) return SizedBox();

  final userName = extractUserName(connector, data, whoIConnected);
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 151.72.h,
      width: 87.2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Color.fromARGB(5, 0, 0, 0), blurRadius: 20)
          ]),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: cachedNetworkImageWidget(
              imageUrl:
                  APICALLS.imageBaseUrl + (data.refId?.profileImage ?? ""),
              width: 68.73.w,
              height: 65.65.w,
              borderRadiusValue: Get.size.width * 0.042,
            ),
          ),
          Container(
            height: 6.h,
          ),
          Expanded(
            child: Text("$userName",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xff8D8D8D),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w400),
                maxLines: 2,
                textAlign: TextAlign.center),
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          SizedBox(
            height: 8.h,
          ),
        ],
      ));
}

Widget smallCard(RefId connector, Requester data, var accepted,
    {bool whoIConnected = false}) {
  if (data == null) return SizedBox();

  final userName = extractUserName(connector, data, whoIConnected);
  return Container(
    height: 41.03,
    width: 150,
    decoration: BoxDecoration(
        color: accepted
            ? Color.fromARGB(17, 9, 206, 53)
            : Color.fromARGB(24, 191, 161, 36),
        borderRadius: BorderRadius.circular(14)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            height: 28.82,
            width: 30.17,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Center(
                child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                APICALLS.imageBaseUrl + (data.refId?.profileImage ?? ""),
              ),
            ))),
        SizedBox(
          width: Get.width * 0.013.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$userName",
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 12),
              ),
              Row(
                children: [
                  accepted
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color(0xff09CE35),
                              borderRadius: BorderRadius.circular(2)),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 8,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SvgPicture.asset("resources/svg/waiting.svg"),
                  SizedBox(
                    width: 5,
                  ),
                  Text(accepted ? "Accepted connect" : "Waiting to accept",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 10))
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget messageProfileCard(
    BuildContext context, ConnectionResponseModel responseData) {
  return Row(
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        width: 39,
        height: 45,
        child: CircleAvatar(
            backgroundImage: NetworkImage(APICALLS.imageBaseUrl +
                (responseData.userId?.profileImage ?? ""))),
      ),
      Text(
        (responseData.userId?.userName == null
            ? (responseData.userId?.userName ?? "")
            : "Message From \n" + "@" + (responseData.userId?.userName ?? "")),
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff575858)),
      ),
    ],
  );
}

Widget messageCard(BuildContext context, {String? title, String? message}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? ""),
        SizedBox(
          height: 6,
        ),
        Container(
          //  width: 307.22,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Text(
            message ?? "",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    ),
  );
}

Widget connectionStatusCard(
    BuildContext context, ConnectionResponseModel responseData,
    {bool whoIConnected = false}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    width: 339,
    height: 89.06,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Color(0xffEBEBEB), borderRadius: BorderRadius.circular(14)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Connection Status:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            smallCard(responseData.userId!, responseData.requester!,
                responseData.isRequesterAccepted,
                whoIConnected: whoIConnected),
            smallCard(responseData.userId!, responseData.contact!,
                responseData.isContactAccepted,
                whoIConnected: whoIConnected),
          ],
        ),
      ],
    ),
  );
}

Widget connectionClosedCard() {
  return Container(
    height: 28.h,
    margin:
        EdgeInsets.only(top: 14.0.h, left: 24.0.w, right: 24.0.w, bottom: 12.h),
    decoration: BoxDecoration(
      color: pluhgGrayColour,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Center(
      child: Text(
        "Connection Closed",
        style: TextStyle(
            color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
      ),
    ),
  );
}

Widget connectionRemainderCard(
    BuildContext context, ConnectionResponseModel responseData) {
  Size size = MediaQuery.of(context).size;
  return Column(children: [
    Visibility(
      visible:
          responseData.isContactAccepted! && responseData.isRequesterAccepted!
              ? false
              : true,
      child: Text("Send Reminder To",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black)),
    ),
    Padding(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: responseData.isRequesterAccepted! ? false : true,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return showPluhgDailog4(
                            context,
                            responseData.requesterPreMessage!,
                            responseData.sId!,
                            'requester');
                      });
                },
                child: button2("Requester"),
              ),
            ),
            SizedBox(
              width: 7.05,
            ),
            Visibility(
              visible: responseData.isContactAccepted! ? false : true,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return showPluhgDailog4(
                            context,
                            responseData.contactPreMessage!,
                            responseData.sId!,
                            'contact');
                      });
                },
                child: button2("Contact"),
              ),
            ),
          ],
        ))
  ]);
}

Widget connectionAcceptedTextCard(ConnectionResponseModel responseData,
    {bool isRequester = false}) {
  return Container(
    margin: EdgeInsets.only(
      top: 12.0.h,
      left: 24.0.w,
      right: 24.0.w,
      bottom: 12.h,
    ),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Color(0xFFA4A4A4),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Center(
      child: Text(
        _getUserName(responseData, isRequester),
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
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

Widget connectionAcceptDeclineCard(ConnectionResponseModel responseData,
    {String? connectionID}) {
  return Visibility(
      visible: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: button3("Accept", pluhgGreenColour),
            onTap: () async {
              HTTPManager()
                  .acceptConnection(
                      ConnectionRequestModel(connectionId: connectionID))
                  .then((value) {
                showPluhgDailog2(
                  Get.context!,
                  "Success",
                  "Accepted Successfully"!,
                  onCLosed: () {
                    print("[Dialogue:OnClose] go to HomeView [2]");
                    if (value.isRequesterAccepted! &&
                        value.isContactAccepted!) {
                      Get.offAll(() => HomeView(
                            index: 2,
                          ));
                    } else {
                      Get.offAll(() => HomeView(
                            index: 0,
                            connectionTabIndex: 1,
                          ));
                    }
                  },
                );
              }).catchError((onError) {
                pluhgSnackBar('Sorry', onError.toString());
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
                  .declineConnection(ConnectionRequestModel(
                      connectionId: connectionID ?? "", reason: 'Unknown ??'))
                  .then((value) {
                showPluhgDailog2(
                  Get.context!,
                  "Success",
                  value.message!,
                  onCLosed: () {
                    print("[Dialogue:OnClose] go to HomeView [2]");
                    Get.offAll(() => HomeView(index: 0, connectionTabIndex: 1));
                  },
                );
              }).catchError((onError) {
                pluhgSnackBar('Sorry', onError.toString());
              });
            },
          ),
        ],
      ));
}

Widget connectionCloseCard(BuildContext context, ConnectionResponseModel data,
    Function refreshActiveConnection,
    {bool isRequester = false}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isRequester && !data.closeConnection!)
          GestureDetector(
            child: button3("Close Connection", pluhgRedColour),
            onTap: () {
              //show dialog with rating
              showDialogWithRating(context, data, refreshActiveConnection);
            },
          ),
        if (data.closeConnection ?? false)
          button3("Connection Closed", pluhgGrayColour),
        SizedBox(
          width: 10.w,
        ),
        outline_button("Conversation", onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        username_receiver: !isRequester
                            ? "@${data.requester?.refId?.userName}"
                            : "@${data.contact?.refId?.userName}",
                        name_receiver: !isRequester
                            ? (data.requester?.refId?.name ?? "")
                            : (data.contact?.refId?.name ?? ""),
                        profile_receiver:
                            "${APICALLS.imageBaseUrl}${!isRequester ? data.requester?.refId?.profileImage : data.contact?.refId?.profileImage}",
                        senderId: isRequester
                            ? (data.requester?.refId?.sId ?? "")
                            : (data.contact?.refId?.sId ?? ""),
                        recevierId: !isRequester
                            ? (data.requester?.refId?.sId ?? "")
                            : (data.contact?.refId?.sId ?? ""),
                      )));
        }),
      ],
    ),
  );
}

void showDialogWithRating(BuildContext buildContext,
    ConnectionResponseModel data, Function refreshActiveConnection) {
  showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return showPluhgRatingDialog(context, "Close connection",
            "To close this connection, rate @${data.userId?.userName}’s connection recomendation",
            onCLosed: (value) {
          ProgressDialog pd = ProgressDialog(context: buildContext);
          pd.show(
            max: 100,
            msg: 'Please wait...',
            progressType: ProgressType.normal,
            progressBgColor: Colors.transparent,
          );
          HTTPManager()
              .closeConnection(ConnectionRequestModel(
                  connectionId: data.sId ?? "",
                  feedbackRating: value.toString()))
              .then((value) {
            pd.close();
            showPluhgDailog2(
              buildContext,
              "Great!!!",
              "You have successfully closed this  connection",
              onCLosed: () {
                Navigator.pop(buildContext);
                refreshActiveConnection();
              },
            );
          }).catchError((onError) {
            pd.close();
            showPluhgDailog(buildContext, "So sorry",
                "Couldn't complete your request, try again");
          });
          // APICALLS()
          //     .closeConnection(connectionID: data["_id"], context: buildContext, rating: value.toString())
          //     .then((value) {
          //   if (value) {
          //     //call active connection API again
          //     pd.close();
          //     showPluhgDailog2(buildContext, "Great!!!", "You have successfully cancelled this  connection",
          //         onCLosed: () {
          //       Navigator.pop(buildContext);
          //       refreshActiveConnection();
          //     });
          //   } else {
          //     pd.close();
          //     showPluhgDailog(buildContext, "So sorry", "Couldn't complete your request, try again");
          //   }
          // });
        });
      });
}
