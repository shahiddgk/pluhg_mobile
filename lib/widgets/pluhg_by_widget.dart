import 'package:flutter/material.dart';
import 'package:plug/widgets/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlugByWidgetCard extends StatelessWidget {
  const PlugByWidgetCard({required this.userName, required this.date, Key? key})
      : super(key: key);
  final String userName;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.height < 812 ? 76.w : 100.w,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 9.45.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Plugged by:",
            style: style_title,
          ),
          Container(
            height: 4.h,
          ),
          Container(
            child: Text(userName.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: subtitleTextStyle),
          ),
          SizedBox(height: 8.71.h),
          Text(
            "Date:",
            style: style_title,
          ),
          Container(
            height: 4.h,
          ),
          Text(
            date.toString().substring(0, 11),
            style: subtitleTextStyle,
          ),
          SizedBox(height: 8.71.h),
          Text(
            "Time:",
            style: style_title,
          ),
          Container(
            height: 4.h,
          ),
          Text(
            date.toString().substring(12),
            style: subtitleTextStyle,
          ),
        ],
      ),
    );
  }
}
