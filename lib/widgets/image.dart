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
    child: Container(padding: EdgeInsets.all(6.w), child: SvgPicture.asset("assets/svg/profile.svg")),
  );
}

networkImage(String imageUrl, {double sideSize = 0}) {
  double size = sideSize == 0 ? 54.w : sideSize;
  return Container(
    decoration: BoxDecoration(
      color: Color(0xffEBEBEB),
      borderRadius: BorderRadius.circular(12.r),
    ),
    width: size,
    height: size,
    child: Padding(
      padding: EdgeInsets.all(6.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          placeholder: (context, url) => Padding(
            padding: EdgeInsets.all(12.w),
            child: pluhgProgress(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    ),
  );
}

cachedNetworkImageWidget({
  required String imageUrl,
  required double height,
  required double width,
  double borderRadiusValue = 100,
}){
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadiusValue),
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => pluhgProgress(),
      height: height,
      width: width,
    ),
  );
}
