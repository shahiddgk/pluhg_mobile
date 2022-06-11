import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/modules/connection_screen/controllers/connection_screen_controller.dart';
import 'package:plug/app/widgets/button.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/screens/chat/chat_screen.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../data/http_manager.dart';
import '../../../data/models/request/connection_request_model.dart';

class ActiveConnectionScreenView extends GetView<ConnectionScreenController> {
  final ConnectionResponseModel data;
  final bool isRequester;
  final Function refreshActiveConnection;

  ActiveConnectionScreenView(
      {required this.data,
      required this.isRequester,
      required this.refreshActiveConnection});

  @override
  Widget build(BuildContext context) {
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parseUTC(data.createdAt!)
        .toLocal();
    String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SimpleAppBar(
          backButton: true,
          notificationButton: false,
        ),
        body: Padding(
            padding: EdgeInsets.all(20.w),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 20.w),
                      child: Text(
                        "${data.userId?.userName!} Pluhgged",
                        style: TextStyle(
                          fontSize: 28.sp,
                          color: pluhgColour,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffEBEBEB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(width: 20.w),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 151.72.h,
                                          width: 87.2.w,
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
                                              data.requester!,
                                              "Requester"),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        Container(
                                          height: 131.72.w,
                                          width: 87.2.w,
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
                                              data.requester!,
                                              "Contact"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 20.w,
                                ),
                                PlugByWidgetCard(
                                  userName:
                                      (data.userId?.userName ?? "").isEmpty
                                          ? data.userId?.name ?? ""
                                          : "@" + (data.userId?.userName ?? ""),
                                  date: formattedDate,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20.w,
                                ),
                                Text(
                                  "Message From @${data.userId?.userName}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff575858)),
                                ),
                              ],
                            ),
                            Container(height: 12.h),
                            Container(
                              height: Get.height / 5,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(12.w),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Text(
                                (data.both ?? "").isEmpty ? "" : "${data.both}",
                                textAlign: TextAlign.justify,
                                maxLines: 25,
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
                      SizedBox(
                        height: 21,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: button3("Close Connection", pluhgRedColour),
                            onTap: () {
                              //show dialog with rating
                              showDialogWithRating(context);
                            },
                          ),
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
                                              ? (data.requester?.refId?.name ??
                                                  "")
                                              : (data.contact?.refId?.name ??
                                                  ""),
                                          profile_receiver:
                                              "${APICALLS.imageBaseUrl}${!isRequester ? data.requester?.refId?.profileImage : data.contact?.refId?.profileImage}",
                                          senderId: isRequester
                                              ? (data.requester?.refId?.sId ??
                                                  "")
                                              : (data.contact?.refId?.sId ??
                                                  ""),
                                          recevierId: !isRequester
                                              ? (data.requester?.refId?.sId ??
                                                  "")
                                              : (data.contact?.refId?.sId ??
                                                  ""),
                                        )));
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  void showDialogWithRating(BuildContext buildContext) {
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
                "You have successfully cancelled this  connection",
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
}
