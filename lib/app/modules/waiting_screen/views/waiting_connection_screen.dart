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
    Size size = MediaQuery.of(context).size;
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
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: size.width * 0.026),
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04,
                                vertical: size.width * 0.05),
                            decoration: BoxDecoration(
                              color: Color(0xffEBEBEB),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            cardProfile2(
                                                context,
                                                responseData.userId!,
                                                responseData.requester!,
                                                "Requester"),
                                            cardProfile2(
                                                context,
                                                responseData.userId!,
                                                responseData.contact!,
                                                "Contact"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    PlugByWidgetCard(
                                        userName:
                                            responseData.userId?.userName ==
                                                    null
                                                ? "Pluhg user"
                                                : "@" +
                                                    (responseData
                                                            .userId?.userName ??
                                                        ""),
                                        date: formattedDate)
                                  ],
                                ),
                                if (responseData.both != null &&
                                    responseData.both != "" &&
                                    responseData.contact?.message != null &&
                                    responseData.contact != "" &&
                                    responseData.requester?.message != null &&
                                    responseData.requester != "")
                                  messageProfileCard(context, responseData),
                                if (responseData.both != null &&
                                    responseData.both != "")
                                  messageCard(context,
                                      title: "Message to Both",
                                      message: responseData.both),
                                if (controller.isRequester.value &&
                                    responseData.requester?.message != null &&
                                    responseData.requester?.message != "")
                                  messageCard(context,
                                      title: "Message to Requester",
                                      message: responseData.requester?.message),
                                if (!controller.isRequester.value &&
                                    responseData.contact?.message != null &&
                                    responseData.contact?.message != "")
                                  messageCard(context,
                                      title: "Message to Contact",
                                      message: responseData.contact?.message),
                              ],
                            ),
                          ),
                          connectionStatusCard(context, responseData),
                          (controller.isRequester.value &&
                                  (responseData.isRequesterAccepted ?? false) || !responseData.isPending!)
                              ? Container()
                              : (!controller.isRequester.value &&
                                      (responseData.isContactAccepted ??
                                          false) || !responseData.isPending!)
                                  ? Container() //connectionAcceptedTextCard(responseData, isRequester: controller.isRequester.value)
                                  : connectionAcceptDeclineCard(responseData,
                                      connectionID: connectionID),
                        ],
                      ),
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
