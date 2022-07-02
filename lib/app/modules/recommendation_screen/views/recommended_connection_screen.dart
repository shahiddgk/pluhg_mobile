import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/modules/recommendation_screen/controllers/recommended_connection_screen_controller.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/widgets/button.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

import '../../../../widgets/colours.dart';

class RecommendedScreenView
    extends GetView<RecommendedConnectionScreenController> {
  String? connectionID;

  RecommendedScreenView({this.connectionID});

  final controller = Get.put(RecommendedConnectionScreenController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SimpleAppBar(backButton: true),
      body: FutureBuilder<ConnectionResponseModel>(
          future: controller.getConnectionDetails(connectionID!),
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
                    .parseUTC(responseData.createdAt ?? "")
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
                                              cardProfile2(
                                                      context,
                                                      responseData.userId!,
                                                      responseData.requester!,
                                                      "Requester",
                                                      whoIConnected: true),
                                             cardProfile2(
                                                      context,
                                                      responseData.userId!,
                                                      responseData.contact!,
                                                      "Contact",
                                                      whoIConnected: true),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(width: 20.w),
                                      Expanded(
                                          child: PlugByWidgetCard(
                                              userName: responseData
                                                          .userId?.userName ==
                                                      null
                                                  ? "Pluhg user"
                                                  : "@" +
                                                      (responseData.userId
                                                              ?.userName ??
                                                          ""),
                                              date: formattedDate))
                                    ],
                                  ),
                                  if (responseData
                                          .requester?.message?.isNotEmpty ??
                                      false)
                                    messageCard(context, title: "Message to Requester", message: responseData.requester?.message),

                                  if (responseData
                                          .contact?.message?.isNotEmpty ??
                                      false)
                                    messageCard(context, title: "Message to Contact", message: responseData.contact?.message),

                                  if (responseData.both?.isNotEmpty ?? false)
                                    messageCard(context, title: "Message to Both", message: responseData.both),

                                ],
                              ),
                            ),
                          ),

                          connectionStatusCard(context, responseData, whoIConnected: true),

                          responseData.closeConnection!
                              ? connectionClosedCard()
                              : connectionRemainderCard(context, responseData),
                                ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text(''), //Text('${snapshot.data?.message}'),
                );
              }
            } else {
              return SizedBox.shrink();
            }
          }),
    );
  }
}
