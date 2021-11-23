import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'colors.dart';

Widget pluhgProgress() {
  return Container(
      height: 50,
      decoration: BoxDecoration(
          color: pluhgColour, borderRadius: BorderRadius.circular(30)),
      child: Lottie.asset("assets/lottie/Pluhgloading.json"));
}
