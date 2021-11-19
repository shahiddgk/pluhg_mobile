import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Text('404 Screen not found!'),
      ),
    );
  }
}
