import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/app/widgets/pluhg_button.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen(
      {Key? key,
      required this.buttonText,
      required this.heading,
      required this.iconName,
      this.onPressed,
      required this.subheading})
      : super(key: key);
  final Function()? onPressed;
  final String heading, subheading, buttonText, iconName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 91.h,
        ),
        SvgPicture.asset('assets/svg/core/$iconName.svg'),
        SizedBox(
          height: 28.h,
        ),
        Text(
          heading,
          style: TextStyle(
              color: AppColors.pluhgColour,
              fontWeight: FontWeight.w600,
              fontSize: 28.sp),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            subheading,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 15.sp),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 261,
          child: PluhgButton(
            text: buttonText,
            onPressed: onPressed,
            fontSize: 15.sp,
            borderRadius: 50,
            verticalPadding: 12.5.h,
          ),
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    ));
  }
}
