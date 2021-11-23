import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/connection_screen_controller.dart';

class WaitingView extends GetView<ConnectionScreenController> {
  final dynamic data;
  WaitingView({this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Waiting is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
