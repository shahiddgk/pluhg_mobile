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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 9.4,
      ),
      Text("Plugged by:", style: style_title),
      Container(
        height: 4.h,
      ),
      Text(userName.toString(), style: subtitleTextStyle),
      SizedBox(height: 8.71.h),
      Text("Date:", style: style_title),
      Container(
        height: 4.h,
      ),
      Text(date.toString().substring(0, 11), style: subtitleTextStyle),
      SizedBox(height: 8.71.h),
      Text("Time:", style: style_title),
      Container(
        height: 4.h,
      ),
      Text(
        date.toString().substring(12),
        style: subtitleTextStyle,
      ),
    ]);
  }
}
