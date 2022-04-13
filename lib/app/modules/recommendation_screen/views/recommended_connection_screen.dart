import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:plug/app/modules/recommendation_screen/controllers/recommended_connection_screen_controller.dart';
import 'package:plug/app/widgets/progressbar.dart';
import 'package:plug/app/widgets/simple_appbar.dart';
import 'package:plug/models/recommendation_response.dart';
import 'package:plug/widgets/button.dart';
import 'package:plug/widgets/connection_profile_card.dart';
import 'package:plug/widgets/dialog_box.dart';
import 'package:plug/widgets/pluhg_by_widget.dart';

class RecommendedScreenView extends GetView<RecommendedConnectionScreenController> {
  String? connectionID;

  RecommendedScreenView({this.connectionID});

  final controller = Get.put(RecommendedConnectionScreenController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SimpleAppBar(backButton: true),
      body: FutureBuilder<RecommendationResponse>(
          future: controller.getWaitingConnection(connectionID!),
          builder: (context, snapshot) {
            if (snapshot. connectionState == ConnectionState.waiting) {
              return Center(child: pluhgProgress());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("$snapshot.error"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.status == true) {
                ResponseData responseData = snapshot.data!.data;
                var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(responseData.createdAt).toLocal();
                String formattedDate = DateFormat("dd MMM yyyy hh:mm").format(dateValue);
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
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: size.width * 0.026),
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
                                                  height: 151.72.h,
                                                  width: 87.2,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(15),
                                                      boxShadow: [
                                                        BoxShadow(color: Color.fromARGB(5, 0, 0, 0), blurRadius: 20)
                                                      ]),
                                                  child: cardProfile2(
                                                      context, responseData.requester.refId.toJson(), "Requester")),
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
                                                        BoxShadow(color: Color.fromARGB(5, 0, 0, 0), blurRadius: 20)
                                                      ]),
                                                  child: cardProfile2(
                                                      context, responseData.contact.refId.toJson(), "Contact")),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(width: 20.w),
                                      Expanded(
                                          child: PlugByWidgetCard(
                                              userName: responseData.userId.userName == null
                                                  ? "Pluhg user"
                                                  : "@" + responseData.userId.userName,
                                              date: formattedDate))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14.79,
                                  ),
                                  Text("Message to @${responseData.requester.name}"),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    //  width: 307.22,
                                    padding: EdgeInsets.all(8),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                    child: Text(
                                      "${responseData.requester.message}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14.79,
                                  ),
                                  Text("Message to @${responseData.contact.name}"),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    //   width: 307.22,
                                    padding: EdgeInsets.all(8),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                    child: Text(
                                      "${responseData.contact.message}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
                            decoration:
                                BoxDecoration(color: Color(0xffEBEBEB), borderRadius: BorderRadius.circular(14)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Connection Status:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    smallCard(responseData.requester.toJson(), responseData.isRequesterAccepted),
                                    smallCard(responseData.contact.toJson(), responseData.isContactAccepted),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: responseData.isContactAccepted && responseData.isRequesterAccepted ? false : true,
                            child: Text("Send Reminder To",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: responseData.isRequesterAccepted ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return showPluhgDailog4(context, responseData.id, 'requester');
                                          });
                                    },
                                    child: button2("Requester"),
                                  ),
                                ),
                                SizedBox(
                                  width: 7.05,
                                ),
                                Visibility(
                                  visible: responseData.isContactAccepted ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return showPluhgDailog4(context, responseData.id, 'contact');
                                          });
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
                );
              } else {
                return Center(
                  child: Text('${snapshot.data!.message}'),
                );
              }
            } else {
              return SizedBox.shrink();
            }
          }),
    );
  }
}
