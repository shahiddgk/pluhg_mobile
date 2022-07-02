import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/data/models/response/connection_response_model.dart';
import 'package:plug/app/modules/connection_screen/controllers/active_connection_screen_controller.dart';
import 'package:plug/app/widgets/colors.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';


class ActiveConnectionScreenView
    extends GetView<ActiveConnectionScreenController> {
  final ConnectionResponseModel data;
  final bool isRequester;
  final Function refreshActiveConnection;

  ActiveConnectionScreenView(
      {required this.data,
      required this.isRequester,
      required this.refreshActiveConnection});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: size.width * 0.022),
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Color(0xffEBEBEB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        cardProfile2(context, data.userId!,
                                            data.requester!, "Requester"),
                                        cardProfile2(context, data.userId!,
                                            data.contact!, "Contact"),
                                      ],
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: PlugByWidgetCard(
                                      userName: data.userId?.userName == null
                                          ? "Pluhg user"
                                          : "@" + (data.userId?.userName ?? ""),
                                      date: formattedDate),
                                )
                              ],
                            ),
                            // SizedBox(
                            //   height: 14.79,
                            // ),
                            if (data.both != null &&
                                data.both != "" &&
                                data.contact?.message != null &&
                                data.contact != "" &&
                                data.requester?.message != null &&
                                data.requester != "")
                              messageProfileCard(context, data),
                            if (data.both != null && data.both != "")
                              messageCard(context,
                                  title: "Message to Both", message: data.both),

                            if (data.requester != null &&
                                isRequester &&
                                data.requester?.message != null &&
                                data.requester?.message != "")
                              messageCard(context,
                                  title: "Message to Requester",
                                  message: data.requester?.message),

                            if (!isRequester &&
                                data.contact != null &&
                                data.contact?.message != null &&
                                data.contact?.message != "")
                              messageCard(context,
                                  title: "Message to Contact",
                                  message: data.contact?.message),
                          ],
                        ),
                      ),
                      connectionCloseCard(
                          context, data, refreshActiveConnection,
                          isRequester: isRequester),
                    ],
                  ),
                ),
              ],
            )));
  }
}
