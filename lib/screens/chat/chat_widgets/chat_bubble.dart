import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/screens/chat/chat_widgets/show_document_widget.dart';
import 'package:plug/screens/chat/chat_widgets/show_images_widget.dart';
import 'package:plug/widgets/models/message.dart';
import 'package:url_launcher/url_launcher.dart';

class BubbleChat extends StatelessWidget {
  BubbleChat(this.message, {Key? key}) : super(key: key);
  Message message;

  @override
  Widget build(BuildContext context) {
    Widget messageDisplay() {
      switch (message.messageType) {
        case 'text':
          return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 240.w),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: (this.message.isMine() ? AppColors.chatColour : AppColors.pluhgGrayColour3),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.h),
                  child: SelectableLinkify(
                    style: TextStyle(fontSize: 14.6.sp, color: Colors.white),
                    text: message.message,
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                  )));
        case 'doc':
          return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 240.w),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: (this.message.isMine() ? AppColors.chatColour : AppColors.pluhgGreyColour),
                  ),
                  padding: EdgeInsets.all(6.w),
                  child: DocumentWidget(List<String>.from(json.decode(message.message))[0])));
        case 'image':
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: (this.message.isMine() ? AppColors.chatColour : AppColors.pluhgGrayColour3),
              ),
              padding: EdgeInsets.all(8.w),
              child: message.message.toString().isEmpty
                  ? Container()
                  : ImagesChatWidget(List<String>.from(json.decode(message.message))));
        default:
          return Container();
      }
    }

    /**

     */
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: this.message.isMine() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 10.h, bottom: 10.h), child: messageDisplay()),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 10.h),
            child: Text(message.time,
                style: TextStyle(
                  color: AppColors.chatColour,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ]);
  }
}
