import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plug/widgets/colours.dart';

pluhgSnackBar(String title, String message) {
  return Get.snackbar(title, message,
      backgroundColor: Colors.white,
      colorText: pluhgColour,
      icon: SvgPicture.asset('assets/svg/core/logo.svg'));
}
