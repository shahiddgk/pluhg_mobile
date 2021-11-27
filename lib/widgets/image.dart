import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_svg/svg.dart';

defaultImage() {
  return Container(
      height: 40,
      width: 30,
      child: SvgPicture.asset("resources/svg/profile.svg"));
}
