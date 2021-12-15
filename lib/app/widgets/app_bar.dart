import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PluhgAppBar extends StatelessWidget implements PreferredSizeWidget {
  PluhgAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, color: Color(0xFF263238))),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );
  }

  static final _appBar = AppBar();
  @override
  Size get preferredSize => _appBar.preferredSize;
}
