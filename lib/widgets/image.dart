import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plug/app/widgets/progressbar.dart';

defaultImage() {
  return Container(
      height: 40,
      width: 30,
      child: SvgPicture.asset("resources/svg/profile.svg"));
}

networkImage(double height, double width, String imageUrl) {
  return Container(
    height: height,
    width: width,
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: pluhgProgress(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}
