import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plug/app/widgets/progressbar.dart';

defaultImage({double sideSize = 0}) {
  double size = sideSize == 0 ? 54.w : sideSize;
  return Container(
    decoration: BoxDecoration(
      color: Color(0xffEBEBEB),
      borderRadius: BorderRadius.circular(12.r),
    ),
    width: size,
    height: size,
    child: Container(padding: EdgeInsets.all(12.w), child: SvgPicture.asset("assets/svg/profile.svg")),
  );
}

networkImage(double height, double width, String imageUrl) {
  return Container(
    height: height,
    width: width,
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => Padding(
        padding: EdgeInsets.all(12.w),
        child: pluhgProgress(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}
