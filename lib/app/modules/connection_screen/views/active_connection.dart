import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/modules/connection_screen/controllers/connection_screen_controller.dart';

class ActiveConnectionScreenView extends GetView<ConnectionScreenController> {
  final dynamic data;
  final bool isRequester;
  ActiveConnectionScreenView({this.data, required this.isRequester});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}
