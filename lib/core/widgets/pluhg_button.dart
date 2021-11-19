import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pluhg/core/values/colors.dart';

class PluhgButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final double? fontSize;
  final double? borderRadius;

  final Function()? onPressed;
  final double? verticalPadding;
  final Color? color, borderColor;

  const PluhgButton(
      {Key? key,
      this.text,
      this.onPressed,
      this.child,
      this.fontSize,
      this.color,
      this.borderColor,
      this.verticalPadding,
      this.borderRadius})
      : assert(text != null || child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: color ?? AppColors.pluhgColour,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 8.h),
              side: BorderSide(
                  color: onPressed == null
                      ? Colors.transparent
                      : borderColor ?? AppColors.pluhgColour),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 59.r),
              )),
          child: text != null
              ? Text(
                  text!,
                  style: TextStyle(
                    fontSize: fontSize ?? 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : child),
    );
  }
}
